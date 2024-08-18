::Hardened.HooksMod.hook("scripts/skills/actives/reload_bolt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost += 1 ;	// In Vanilla this is 4
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		this.getContainer().add(::new("scripts/skills/effects/hd_reload_disorientation_effect"));
		return __original(_user, _targetTile);
	}
});
