::Hardened.HooksMod.hook("scripts/skills/actives/line_breaker", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.IsAttack = false;	// Vanilla: true
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		// This skill is no longer an attack, so we need to manually make sure you can't use it on allies
		if (ret && this.getContainer().getActor().isAlliedWith(_targetTile.getEntity())) ret = false;

		return ret;
	}
});
