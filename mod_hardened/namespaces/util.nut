// Namespace for generic global utility functions
::Hardened.util <- {};

// If the offhand item worn by _entity is equal to any of the IDs inside _existingShieldIDArray, then it is unEquipped and instead _newShieldPath is added
// If _existingShieldIDArray is not given/null, the ID check is ignored and the offhand is always replaced
/// @param _entity the entity, whose equipment we are replacing
/// @param _newShieldPath full script path to the new item that we want to equip to the entity. If null, then the old item is only unequipped
/// @param _existingShieldIDArray array of IDs that we want to replace. If null, then we replace anything at the slot
// Returns true if the offhand item was replaced, return false otherwise
::Hardened.util.replaceOffhand <- function( _entity, _newShieldPath = null, _existingShieldIDArray = null )
{
	local shield = _entity.getOffhandItem();
	if (shield != null)
	{
		if (_existingShieldIDArray == null)
		{
			_entity.getItems().unequip(shield);
			if (_newShieldPath != null) _entity.getItems().equip(::new(_newShieldPath));
			return true;
		}
		else
		{
			foreach (existingShieldID in _existingShieldIDArray)
			{
				if (shield.getID() == existingShieldID)
				{
					_entity.getItems().unequip(shield);
					if (_newShieldPath != null) _entity.getItems().equip(::new(_newShieldPath));
					return true;
				}
			}
		}
	}
	return false;
}

// If the mainhand item worn by _entity is equal to any of the IDs inside _existingIDArray, then it is unEquipped and instead _newItemPath is added
// If _existingIDArray is not given/null, the ID check is ignored and the mainhand is always replaced
// Returns true if the offhand item was replaced, return false otherwise
::Hardened.util.replaceMainhand <- function( _entity, _newItemPath, _existingIDArray = null )
{
	local mainHandItem = _entity.getMainhandItem();
	if (mainHandItem != null)
	{
		if (_existingIDArray == null)
		{
			_entity.getItems().unequip(mainHandItem);
			_entity.getItems().equip(::new(_newItemPath));
			return true;
		}
		else
		{
			foreach (existingItemID in _existingIDArray)
			{
				if (mainHandItem.getID() == existingItemID)
				{
					_entity.getItems().unequip(mainHandItem);
					_entity.getItems().equip(::new(_newItemPath));
					return true;
				}
			}
		}
	}
	return false;
}

// If there is a bag item on the character equal to any of the IDs inside _existingIDArray, then it is removed and _newItemPath is added to the first empty slot
// This function will replaces all bag items found
// Returns true if any bag item was replaced, return false otherwise
::Hardened.util.replaceBagItem <- function( _entity, _newItemPath, _existingIDArray )
{
	local replacedSomething = false;

	local items = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
	foreach (item in items)
	{
		if (_existingIDArray.find(item.getID()) != null)
		{
			_entity.getItems().removeFromBag(item);
			_entity.getItems().addToBag(::new(_newItemPath));
			replacedSomething = true;
		}
	}

	return replacedSomething;
}

// Share _experience equally among all brothers in the player roster, never giving any singular brother more than _maximumXPFractionPerBrother
// @return experience given to every single brother
// _excludedBrotherIDs - array of brother id's which are meant to be excluded from receiving XP
::Hardened.util.shareExperience <- function( _experience, _maximumXPFractionPerBrother, _excludedBrotherIDs = [] )
{
	local roster = ::World.getPlayerRoster().getAll();
	local brotherCount = roster.len() - _excludedBrotherIDs.len();
	if (brotherCount == 0) return;

	local maximumXP = _experience * _maximumXPFractionPerBrother;
	local xpPerBrother = ::Math.min(maximumXP, _experience / brotherCount);

	foreach (otherBro in roster)
	{
		if (_excludedBrotherIDs.find(otherBro.getID()) == null)		// Skip every brother that was meant to be excluded from the xp receiving
		{
			otherBro.addXP(xpPerBrother, false);	// This xp does not scale with other modifiers. It already scaled with them when it was first acquired
			otherBro.updateLevel();
		}
	}

	::MSU.Log.printData(::Tactical.getCamera().queryEntityOverlays(), 2)

	return xpPerBrother;
}

// Todo: eventually either remove it or see if it can be used for something else
::Hardened.util.migratePerk <- function( _player, _oldPerkId, _newPerkId )
{
	local perkTree = _player.getPerkTree();
	if (perkTree.hasPerk(_oldPerkId))
	{
		local oldPerkInfo = perkTree.getPerk(_oldPerkId);
		local newPerkDef = ::Const.Perks.findById(_newPerkId);

		local perkTier = oldPerkInfo.Row + 1;
		local perkRow = perkTier;
		local perkPosition = 0;
		foreach (rowIndex, row in perkTree.getTree())
		{
			foreach (perkIndex, perk in row)
			{
				if (perk.ID == _oldPerkId)
				{
					perkRow = rowIndex;
					perkPosition = perkIndex;
					break;
				}
			}
		}

		// Insert our standalone perk at the exact same position into the perk tree, as where the old perk was
		::Hardened.FlaggedPerks.addPerk(perkTree, newPerkDef, perkTier, perkRow, perkPosition);
		perkTree.removePerk(_oldPerkId);	// Remove the old perk from the Perk Tree

		// Replace old perk with our standalone new perk, if the former was unlocked
		if (_player.hasPerk(_oldPerkId))
		{
			_player.getSkills().removeByID(_oldPerkId);
			_player.getSkills().add(::new(newPerkDef.Script));
		}
	}
}

::Hardened.util.intToHex <- function( _unsignedInteger )
{
	local ret = format("%x", _unsignedInteger);
	if (ret.len() == 1) ret = "0" + ret;
	return ret;
}

// Check, whether _startTile and _targetTile are on the same axis
// @return true, if they are on the same axis, or false otherwise
::Hardened.util.isOnSameAxis <- function( _startTile, _targetTile )
{
	if (_startTile.X == _targetTile.X) return true;
	if (_startTile.Y == _targetTile.Y) return true;
	if (_startTile.X + _startTile.Y == _targetTile.X + _targetTile.Y) return true;
	return false;
}

// Look for an empty tile, to knock the target back to
// Knocking back someone over multiple times must have a natural path of empty, non-hill tiles in between
// Note: This function employs recursion. With a high _knockBackDistance or many potential targets, it might require some performance power
// @param _userTile the tile of the user
// @param _targetTile the tile of the target
// @param _knockBackDistance the distance, we want to knock the target back to
// @param _originalTargetTile is a reference to the original _targetTile. It must be kept at null. Its important to make sure we push the enemy away from the origin each time
// @return refence to the tile, that was found for the knocking back
// @return null, if no tile was found
::Hardened.util.findTileToKnockBackTo <- function( _userTile, _targetTile, _knockBackDistance = 1, _originalTargetTile = null )
{
	if (_knockBackDistance <= 0) return null;
	if (_originalTargetTile == null) _originalTargetTile = _targetTile;

	local distanceToTarget = _userTile.getDistanceTo(_targetTile);
	local potentialTargets = [];
	foreach (potentialTile in ::MSU.Tile.getNeighbors(_targetTile))
	{
		if (!potentialTile.IsEmpty) continue;	// We can't push enemies into, or over object
		if (_userTile.getDistanceTo(potentialTile) <= distanceToTarget) continue;	// Knock Back destinations must further away than initial target

		local levelDifference = potentialTile.Level - _targetTile.Level;
		if (levelDifference > 1) continue;		// We can't knock back targets 2 levels upwards or through heights that are more than 2 levels upwards

		// Knock Backs on the same axis always have priority. That's why we potentially return early and disregard the neighbor options
		if (::Hardened.util.isOnSameAxis(_userTile, potentialTile))
		{
			if (_knockBackDistance == 1)
			{
				return potentialTile;
			}
			else
			{
				local ret = this.findTileToKnockBackTo(_userTile, potentialTile, _knockBackDistance - 1, _originalTargetTile);
				if (ret != null)
				{
					return ret;
				}
			}
		}

		potentialTargets.push(potentialTile);
	}

	::MSU.Array.shuffle(potentialTargets);
	foreach (target in potentialTargets)
	{
		if (_knockBackDistance == 1)
		{
			return target;
		}
		else
		{
			local ret = this.findTileToKnockBackTo(_userTile, target, _knockBackDistance - 1, _originalTargetTile);
			if (ret != null) return ret;
		}
	}

	// We checked all our 2-3 options, but none of them were valid
	if (_targetTile.isSameTileAs(_originalTargetTile))
	{
		return null;	// We couldn't push _targetTile away even a single time
	}
	else
	{
		return _targetTile;	// We couldn't push _targetTile any further, so _targetTile as the destination has to do
	}
}

// Look for a ranged weapon in the bag and if found, swap it with the equipped melee weapon
// This can be used before the fight to make sure the enemy does not waste quickhands on their first turn to swap to the ranged weapon
// @param _actor instance of actor whose weapons we want to swap
// @return true if a swap happened or false, if not
::Hardened.util.preSwapRangedWeapon <- function( _actor )
{
	local mainhandItem = _actor.getMainhandItem();
	if (mainhandItem != null && mainhandItem.isItemType(::Const.Items.ItemType.RangedWeapon)) return false;	// We already have a ranged weapon equipped

	local rangedBagItem = null;
	foreach (bagItem in _actor.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag))
	{
		if (bagItem.isItemType(::Const.Items.ItemType.RangedWeapon))
		{
			rangedBagItem = bagItem;
			break;
		}
	}
	if (rangedBagItem == null) return false;	// There is no ranged weapon to swap to

	if (mainhandItem == null)
	{
		_actor.getItems().removeFromBag(rangedBagItem);
		_actor.getItems().equip(rangedBagItem);
	}
	else
	{
		_actor.getItems().swap(mainhandItem, rangedBagItem);
	}

	return true;
}

// Return the number of player characters and clamp that value between 6 and the maximum amount of brothers that the player can field at once
// This function is meant as a baseline for custom generateIdealSize implementations in dynamic parties
::Hardened.util.genericGenerateIdealSize <- function()
{
	if (!("Assets" in ::World) || ::World.Assets == null) return ::DynamicSpawns.Const.MainMenuIdealSize;	// fix for when we test a party in the main menu
	return Math.clamp(::World.getPlayerRoster().getSize(), 6, 12);
}

// Return the corpse name of _corpse in a color, depending on whether it was a player corpse or a non-player one
// This function works similar to
::Hardened.util.getColorizedCorpseName <- function( _corpse )
{
	local color = _corpse.IsPlayer ? "#1e468f" : "#8f1e1e";		// Same color scheme as the vanilla ::Const.UI.getColorizedEntityName function

	return ::MSU.Text.color(color, _corpse.CorpseName);
}

// Make _sourceHelmet appear as if it was actually _targetHelmetScript
// Needs to be called during create of _sourceHelmet
::Hardened.util.impersonateHelmet <- function( _sourceHelmet, _targetHelmetScript )
{
	local newHelmet = ::new(_targetHelmetScript);

	// Adjust stats
	_sourceHelmet.m.Value = newHelmet.m.Value;
	_sourceHelmet.m.ConditionMax = newHelmet.m.ConditionMax;
	_sourceHelmet.m.StaminaModifier = newHelmet.m.StaminaModifier;
	_sourceHelmet.m.Vision = newHelmet.m.Vision;

	// Adjust visual appearance
	_sourceHelmet.m.Name = newHelmet.m.Name;
	_sourceHelmet.m.Description = newHelmet.m.Description;
	_sourceHelmet.m.Variant = newHelmet.m.Variant;
	_sourceHelmet.m.VariantString = newHelmet.m.VariantString;
	_sourceHelmet.updateVariant();

	// Overwrite Functions, so that changing color behaves as if this was the new helmet
	if ("setPlainVariant" in newHelmet) _sourceHelmet.setPlainVariant <- newHelmet.setPlainVariant;
	if ("onPaint" in newHelmet) _sourceHelmet.onPaint <- newHelmet.onPaint;
}

// Find a PlayerBanner that is used by neither the player nor another world party and return it
::Hardened.util.findUnusedMercenaryBanner <- function()
{
	local possibleBanners = clone ::Const.PlayerBanners;

	// Remove PlayerBanner
	::MSU.Array.removeByValue(possibleBanners, ::World.Assets.getBanner());

	foreach (factionID, faction in ::World.FactionManager.m.Factions)
	{
		if (faction == null) continue;
		foreach (worldParty in faction.m.Units)
		{
			::MSU.Array.removeByValue(possibleBanners, "banner_" + worldParty.getBannerID());
		}
	}

	foreach (location in ::World.EntityManager.getLocations())
	{
		::MSU.Array.removeByValue(possibleBanners, "banner_" + location.getBannerID());
	}

	if (possibleBanners.len() == 0)
	{
		::logWarning("Hardened::findUnusedPlayerBanner: No unused mercenary banner was found. PlayerBanner is returned instead.");
		return ::World.Assets.getBanner();
	}

	return ::MSU.Array.rand(possibleBanners);
}
