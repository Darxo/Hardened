// Namespace for generic global utility functions
::Hardened.util <- {};

// If the offhand item worn by _entity is equal to any of the IDs inside _existingShieldIDArray, then it is unEquipped and instead _newShieldPath is added
// If _existingShieldIDArray is not given/null, the ID check is ignored and the offhand is always replaced
// Returns true if the offhand item was replaced, return false otherwise
::Hardened.util.replaceOffhand <- function( _entity, _newShieldPath, _existingShieldIDArray = null )
{
	local shield = _entity.getOffhandItem();
	if (shield != null)
	{
		if (_existingShieldIDArray == null)
		{
			_entity.getItems().unequip(shield);
			_entity.getItems().equip(::new(_newShieldPath));
			return true;
		}
		else
		{
			foreach (existingShieldID in _existingShieldIDArray)
			{
				if (shield.getID() == existingShieldID)
				{
					_entity.getItems().unequip(shield);
					_entity.getItems().equip(::new(_newShieldPath));
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

	return xpPerBrother;
}
