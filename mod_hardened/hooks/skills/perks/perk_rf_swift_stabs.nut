::Hardened.wipeClass("scripts/skills/perks/perk_rf_swift_stabs");

// This will dynamically adjust a dagger skill to behave like Lunge at 2 tile distance
local hookDaggerAttack = function( _o )
{
	// Public
	_o.m.SoundOnLunge <- [	// This sound is played, when a lunge attack is happening
		"sounds/combat/dlc2/lunge_move_01.wav",
		"sounds/combat/dlc2/lunge_move_02.wav",
		"sounds/combat/dlc2/lunge_move_03.wav",
		"sounds/combat/dlc2/lunge_move_04.wav",
	];

	// Create
	_o.setBaseValue("MaxRange", 2);
	_o.m.HD_IgnoreForCrowded = true;	// Otherwise we get a tooltip about crowded and crowded would affect our attacks

	local oldGetTooltip = _o.getTooltip;
	_o.getTooltip = function()
	{
		local ret = oldGetTooltip();

		ret.extend([
			{
				id = 30,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Moves the user next to the target, before attacking, ignoring [Zone of Control|Concept.ZoneOfControl], when used at a distance of 2 tiles")
			},
			{
				id = 31,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Moves the user back to his original tile, after hitting, ignoring [Zone of Control|Concept.ZoneOfControl], when used at a distance of 2 tiles")
			}
		]);

		return ret;
	}

	local oldOnVerifyTarget = _o.onVerifyTarget;
	_o.onVerifyTarget = function( _originTile, _targetTile )
	{
		if (!oldOnVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_originTile.getDistanceTo(_targetTile) == 2)
		{
			if (this.getContainer().getActor().getCurrentProperties().IsRooted) return false;
			if (this.getValidLungeTile(_originTile, _targetTile) == null) return false;
		}

		return true
	}

	// TODO: improve code using onbefore skill executed events
	local oldUse = _o.use;
	_o.use = function( _targetTile, _forFree = false )
	{
		local isDoingLunge = (this.getContainer().getActor().getTile().getDistanceTo(_targetTile) == 2);
		local oldSoundOnUse = this.m.SoundOnUse;
		if (isDoingLunge)
		{
			// Switcheroo of SoundOnUse file, because at a distance of 2 tiles we lunge first, which makes a different sound
			this.m.SoundOnUse = this.m.SoundOnLunge;
		}

		local ret = oldUse(_targetTile, _forFree);

		// Revert switcheroo
		if (isDoingLunge)
		{
			this.m.SoundOnUse = oldSoundOnUse;
		}

		return ret;
	}

	local oldOnuse = _o.onUse;
	_o.onUse = function( _user, _targetTile )
	{
		if (this.getContainer().getActor().getTile().getDistanceTo(_targetTile) == 2)
		{
			return this.onUseLunge(_user, _targetTile);
		}
		else
		{
			return oldOnuse(_user, _targetTile);
		}
	}

  // New Functions
	_o.onUseLunge <- function( _user, _targetTile )
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		local destTile = this.getValidLungeTile(myTile, _targetTile);
		if (destTile == null)
		{
			return false;
		}

		local tag = {
			Skill = this,
			User = _user,
			OldTile = _user.getTile(),
			TargetTile = _targetTile,
			OnRepelled = this.onRepelled,
			OnReturned = this.onReturnToOrigin,
		};
		_user.spawnTerrainDropdownEffect(myTile);

		this.getContainer().setBusy(true);
		::Tactical.getNavigator().teleport(_user, destTile, this.onLungeDone.bindenv(this), tag, false, 3.0);
		return true;
	}

	// Return a valid tile to lunge into for reaching _targetTile. Returns null if no tile was found
	// A valid tile must be empty, adjacent to this character, not steeper than 1 level to myself and not steeper than 1 level to the target
	// The first valid tile clockwise starting with above the _targetTile is returned
	_o.getValidLungeTile <- function( _originTile, _targetTile )
	{
		foreach (tile in ::MSU.Tile.getNeighbors(_targetTile))
		{
			if (tile.IsEmpty && tile.getDistanceTo(_originTile) == 1 && ::Math.abs(_originTile.Level - tile.Level) <= 1 && ::Math.abs(_targetTile.Level - tile.Level) <= 1)
			{
				return tile;
			}
		}

		return null;
	}

	// This character has used Lunge and was just teleported to the valid tile next to the target
	_o.onLungeDone <- function( _entity, _tag )
	{
		if (this.checkForRepel(_entity, _tag))
		{
			return;
		}

		// These two are
		// this.spawnAttackEffect(_tag.TargetTile, ::Const.Tactical.AttackEffectThrust);
		if ((this.m.IsAudibleWhenHidden || user.getTile().IsVisibleForPlayer) && this.m.SoundOnUse.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Skill * this.m.SoundVolume, _entity.getPos());
		}

		local success = this.useForFree(_tag.TargetTile);	// Use onUse once again, this time against an adjacent target
		if (success)	// We return to the original tile only after a successful hit
		{
			::Time.scheduleEvent(::TimeUnit.Virtual, 50, _tag.OnReturned, _tag);
		}
	}

	// Returns true if the character was repelled. Returns false otherwise
	_o.checkForRepel <- function( _entity, _tag )
	{
		local myTile = _entity.getTile();
		local ZOC = [];
		this.getContainer().setBusy(false);

		foreach (tile in ::MSU.Tile.getNeighbors(myTile))
		{
			if (tile.IsOccupiedByActor)
			{
				local actor = tile.getEntity();
				if (!actor.isAlliedWith(_entity) && !actor.getCurrentProperties().IsStunned)
				{
					ZOC.push(actor);
				}
			}
		}

		foreach (actor in ZOC)
		{
			if (!actor.onMovementInZoneOfControl(_entity, true))
			{
				continue;
			}

			if (actor.onAttackOfOpportunity(_entity, true))
			{
				if (_tag.OldTile.IsVisibleForPlayer || myTile.IsVisibleForPlayer)
				{
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_entity) + " lunges and is repelled");
				}

				if (!_entity.isAlive() || _entity.isDying())
				{
					return;
				}

				local dir = myTile.getDirectionTo(_tag.OldTile);

				if (myTile.hasNextTile(dir))
				{
					local tile = myTile.getNextTile(dir);

					if (tile.IsEmpty && ::Math.abs(tile.Level - myTile.Level) <= 1 && tile.getDistanceTo(actor.getTile()) > 1)
					{
						_tag.TargetTile = tile;
						::Time.scheduleEvent(::TimeUnit.Virtual, 50, _tag.OnRepelled, _tag);
						return true;
					}
				}
			}
		}

		return false;
	}

	// This attack was countered by an enemy spearwall or similar skill. This character returned to its original tile
	_o.onRepelled <- function( _tag )
	{
		::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
	}

	_o.onReturnToOrigin <- function( _tag )
	{
		::Tactical.getNavigator().teleport(_tag.User, _tag.OldTile, null, null, false);
	}
}

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_swift_stabs", function(q) {
	q.create <- function()
	{
		this.m.ID = "perk.rf_swift_stabs";
		this.m.Name = ::Const.Strings.PerkName.RF_SwiftStabs;
		this.m.Description = ::Const.Strings.PerkDescription.RF_SwiftStabs;
		this.m.Icon = "ui/perks/perk_rf_swift_stabs.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.onAfterUpdate <- function( _properties )
	{
		foreach (_activeSkill in this.getContainer().getActor().getSkills().getAllSkillsOfType(::Const.SkillType.Active))
		{
			// By checking for MaxRange we guarantee that the same skill is never hooked twice as the MaxRange is increased during the hooking
			if (_activeSkill.isAttack() && _activeSkill.getBaseValue("MaxRange") == 1)
			{
				local item = _activeSkill.getItem();
				if (!::MSU.isNull(item) && item.isItemType(::Const.Items.ItemType.Weapon) && item.isWeaponType(::Const.Items.WeaponType.Dagger))
				{
					// use locally defined function
					hookDaggerAttack(_activeSkill);
				}
			}
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isDisarmed()) return false;

		local weapon = actor.getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Dagger)) return false;

		return true;
	}
});
