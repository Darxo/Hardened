::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Public
	q.m.GrantsXPOnDeath <- true;	// After initialisation this should ideally only ever be set in one direction (to false)

	// Private
	q.m.HD_recoveredHitpointsOverflow <- 0.0;	// float between 0.0 and 1.0. Is not deserialized, meaning that we lose a tiny bit hitpoint recovery when saving/loading often

	q.isTurnDone = @(__original) function()
	{
		if (this.getCurrentProperties().IsStunned) return true;		// Stun no longer sets the Action Points to 0 so we now need to adjust this function to always return true for stunned characters
		return __original();
	}

	q.onMovementStep = @(__original) function( _tile, _levelDifference )
	{
		// Switcheroo to prevent the vanilla implementation from calling updateVisibility
		local oldUpdateVisibility = this.updateVisibility;
		this.updateVisibility = function( _tile, _vision, _faction ) {};

		local ret = __original(_tile, _levelDifference);

		this.updateVisibility = oldUpdateVisibility;

		return ret;
	}

	q.onMovementFinish = @(__original) function ( _tile )
	{
		this.getSkills().update();	// This will allow skills to influence the vision of this entity, before updateVisibility with the destination tile is called
		__original(_tile);
	}

	q.hasZoneOfControl = @(__original) function()
	{
		return __original() && this.getCurrentProperties().CanExertZoneOfControl;
	}

	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		if (_hitInfo.BodyPart == ::Const.BodyPart.Head)
		{
			// Vanilla Fix: Revert hidden vanilla 1.25 threshold multiplier for headshots
			_hitInfo.InjuryThresholdMult *= 0.8;
		}
		__original(_attacker, _skill, _hitInfo);
	}

	// For Vanilla you'd hook onActorKilled on player.nut. But Reforged moved the exp calculation over into the onDeath of actor.nut
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		local lootTile = _tile;
		if (lootTile == null && this.isPlacedOnMap()) lootTile = this.getTile();
		if (lootTile != null)
		{
			foreach (item in this.getDroppedLoot(_killer, _skill, _fatalityType))
			{
				item.drop(lootTile);
			}
		}

		local oldGlobalXPMult = ::Const.Combat.GlobalXPMult;
		if (!this.m.GrantsXPOnDeath) ::Const.Combat.GlobalXPMult = 0;

		__original(_killer, _skill, _tile, _fatalityType);

		::Const.Combat.GlobalXPMult = oldGlobalXPMult;
	}

	q.onTurnEnd = @(__original) function()
	{
		__original();
		this.m.IsTurnStarted = true;
		// Vanilla sets this to false here, which is misleading and annyoing for modder and effect implementations
		// Someone who ended their turn still has had their turn started this round
		// Vanilla already resets this at the start of each round to false
	}

	q.setHitpoints = @(__original) function( _newHitpoints )
	{
		// We redirect any positive changes to the hitpoints to use recoverHitpoints and therefor be affected by the new 'HitpointRecoveryMult' property
		if (_newHitpoints > this.getHitpoints())
		{
			this.__recoverHitpointsSwitcheroo(_newHitpoints - this.getHitpoints());
		}
		else
		{
			__original(_newHitpoints);
		}
	}

// New Events
	// This is called just before onDeath of this entity is called. All returned items are being dropped as loot if the loot is assigned to the player
	// @return array of instantiated items
	q.getDroppedLoot <- function( _killer, _skill, _fatalityType )
	{
		return [];
	}

// New Utility Functions:
	/// Utility function similar to the MSU function ::Tactical.TurnSequenceBar.isActiveEntity except that it first checks whether we are even in combat
	/// @return true if it is currently this entities turn
	/// @return false otherwise
	q.isActiveEntity <- function()
	{
		return ::MSU.Utils.hasState("tactical_state") && ::Tactical.TurnSequenceBar.isActiveEntity(this);
	}

	/*
	Try to recover up to _amount Action Points
	@param _printLog if true, print a combat log entry stating how many Action Points were recovered
	@param _canExceedMaximum if true, then the maximum Action Points can be exceeded.
		Note: This only makes sense if you also increase the maximum action points with that same skill, otherwise they can clamped again during the next onUpdate loop
	@return actual amount of ActionPoints recovered
	*/
	q.recoverActionPoints <- function( _amount, _printLog = true, _canExceedMaximum = false )
	{
		if (_amount <= 0) return;

		local oldActionPoints = this.getActionPoints();

		if (_canExceedMaximum)
		{
			this.setActionPoints(this.getActionPoints() + _amount);
		}
		else
		{
			this.setActionPoints(::Math.min(this.getActionPointsMax(), this.getActionPoints() + _amount));
		}

		local recoveredActionPoints = this.getActionPoints() - oldActionPoints;
		if (_printLog && recoveredActionPoints > 0 && this.isPlacedOnMap() && this.getTile().IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this) + " recovers " + ::MSU.Text.colorGreen(recoveredActionPoints) + " Action Points");
		}

		return recoveredActionPoints;
	}

	// Recover hitpoints up to the maximum and return the amount of hitpoints that were recovered
	// _hitpoints are being scaled by the character property 'HitpointRecoveryMult'
	// @return amount of hitpoints recovered
	q.recoverHitpoints <- function( _hitpointsToRecover, _printLog = false )
	{
		if (_hitpointsToRecover <= 0.0) return 0;
		if (this.getHitpoints() == this.getHitpointsMax()) return 0;

		_hitpointsToRecover = _hitpointsToRecover * this.getCurrentProperties().HitpointRecoveryMult;
		_hitpointsToRecover += this.m.HD_recoveredHitpointsOverflow;

		local flooredRecoveredHitpoints = ::Math.floor(_hitpointsToRecover);
		this.m.HD_recoveredHitpointsOverflow = _hitpointsToRecover - flooredRecoveredHitpoints;

		// Never recover more hitpoints than the maximum hitpoints
		flooredRecoveredHitpoints = ::Math.min(flooredRecoveredHitpoints, this.getHitpointsMax() - this.getHitpoints());

		this.m.Hitpoints = this.getHitpoints() + flooredRecoveredHitpoints;

		if (_printLog && ::MSU.Utils.hasState("tactical_state") && flooredRecoveredHitpoints > 0 && this.isPlacedOnMap() && !this.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this) + " recovers " + ::MSU.Text.colorGreen(flooredRecoveredHitpoints) + " Hitpoints");
		}

		this.onUpdateInjuryLayer();

		return flooredRecoveredHitpoints;
	}

	// Private function only meant for converting instances of vanilla hitpoint recovery to utilize our new system
	q.__recoverHitpointsSwitcheroo <- function( _hitpointsToRecover )
	{
		if (!::MSU.Utils.hasState("tactical_state"))	// Outside of battle we can't generate combat logs so there are no logs we need to prevent from showing
		{
			this.recoverHitpoints(_hitpointsToRecover);
			return;
		}

		this.recoverHitpoints(_hitpointsToRecover, true);

		// We do a switcheroo on the log function from the combat log to prevent the very next attempt of Vanilla to produce their own combat log for hitpoints recovered
		// That is important because with the new HitpointRecoveryMult property that log can be wrong
		// Instead we print our or own correct combat log
		local combatLog = ::Tactical.State.m.TacticalScreen.m.TopbarEventLog;
		local oldLog = combatLog.log;
		combatLog.log = function( _text )
		{
			if (_text.find("" + _hitpointsToRecover) != null)
			{
				// do nothing - The very next time, that Vanilla wants to print a combat log containing _hitpointsToRecover, we prevent that
			}
			else
			{
				oldLog(_text);
			}

			combatLog.log = oldLog;	// Revert the vanilla log function to what it was before
		}
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
	q.onMovementStep = @(__original) function( _tile, _levelDifference )
	{
		local ret = __original(_tile, _levelDifference);

		// We skipped Vanillas updateVisibility call so we will do that now at the very end.
		// This will give skills time to call a last-minute update with an adjusted Vision value when they grant it depending on terrain/tile conditions
		if (ret)
		{
			this.updateVisibilityForFaction();
		}

		return ret;
	}
});
