::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
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
});
