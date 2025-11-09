::Hardened.HooksMod.hook("scripts/skills/actives/rf_net_pull_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "skills/hd_net_pull_skill.png";	// This modified icon has more contrast and is brighter
		this.m.IsAttack = false;	// In Reforged this is true
		this.m.FatigueCost = 30;	// In Reforges this is 25
		this.m.MaxRange = 3;	// In Reforged this is 2
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		// This skill is no longer an attack, so we need to manually make sure you can't use it on allies
		if (ret && this.getContainer().getActor().isAlliedWith(_targetTile.getEntity())) ret = false;

		return ret;
	}
});
