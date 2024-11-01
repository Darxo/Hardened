::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
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

// New Utility Functions:
	// Recover hitpoints up to the maximum and return the amount of hitpoints that were recovered
	// _hitpoints are being scaled by the character property 'HitpointRecoveryMult'
	q.recoverHitpoints <- function( _hitpointsToRecover, _printLog = false )
	{
		if (_hitpointsToRecover <= 0.0) return 0;
		if (this.getHitpoints() == this.getHitpointsMax()) return 0;

		_hitpointsToRecover = ::Math.round(_hitpointsToRecover * this.getCurrentProperties().HitpointRecoveryMult);

		// Never recover more hitpoints than the maximum hitpoints
		_hitpointsToRecover = ::Math.min(_hitpointsToRecover, this.getHitpointsMax() - this.getHitpoints());

		this.m.Hitpoints = ::Math.round(this.getHitpoints() + _hitpointsToRecover);

		if (_printLog && ::MSU.Utils.hasState("tactical_state") && _hitpointsToRecover > 0 && this.isPlacedOnMap() && !this.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this) + " recovers " + ::MSU.Text.colorGreen(_hitpointsToRecover) + " Hitpoints");
		}

		this.onUpdateInjuryLayer();

		return _hitpointsToRecover;
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
