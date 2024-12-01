::Hardened.HooksMod.hook("scripts/skills/actives/disarm_skill", function(q) {
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		return ret && !_targetTile.getEntity().getCurrentProperties().IsImmuneToDisarm;
	}
});
