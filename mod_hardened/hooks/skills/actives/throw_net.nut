::Hardened.HooksMod.hook("scripts/skills/actives/throw_net", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 4; // Reforged: 5; Vanilla: 4
		this.m.MaxRange = 3;		// Reforged: 2; Vanilla: 3
		this.m.IsAttack = false;	// In Vanilla this is true
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		// Switcheroo of BeastHuge so that we effectively disable the reforged condition where you cant net someone with a certain base reach
		local oldBeastHuge = ::Reforged.Reach.Default.BeastHuge;
		::Reforged.Reach.Default.BeastHuge = 9000;

		local ret = __original(_originTile, _targetTile);

		// This skill is no longer an attack, so we need to manually make sure you can't use it on allies
		if (ret && this.getContainer().getActor().isAlliedWith(_targetTile.getEntity())) ret = false;

		::Reforged.Reach.Default.BeastHuge = oldBeastHuge;
		return ret;
	}
});
