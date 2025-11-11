::Hardened.HooksMod.hook("scripts/skills/actives/insects_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ActionPointCost = 3;		// Vanilla: 6
		this.m.MaxRange = 4;			// Vanilla: 7
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return __original(_originTile, _targetTile) && !_targetTile.getEntity().getSkills().hasSkill("effects.hd_headless");
	}
});
