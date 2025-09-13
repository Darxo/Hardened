::Hardened.HooksMod.hook("scripts/skills/actives/swallow_whole_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Swallow an adjacent player controlled character. Cannot be used while netted.";
		this.m.IsAttack = false;	// Vanilla: true; We turn this off as it otherwise synergises with various perks
	}

	q.isUsable = @(__original) function()
	{
		if (this.getContainer().hasSkill("effects.net"))
		{
			return false;
		}

		return __original();
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		// This skill is no longer an attack, so we need to manually make sure you can't use it on allies
		if (ret && this.getContainer().getActor().isAlliedWith(_targetTile.getEntity())) ret = false;

		return ret;
	}
});
