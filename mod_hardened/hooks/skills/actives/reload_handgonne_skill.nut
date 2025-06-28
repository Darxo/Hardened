// The modular vanilla hook for this perk is being sniped in
::Hardened.HooksMod.hook("scripts/skills/actives/reload_handgonne_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 7;		// Vanilla: 9
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		this.getContainer().add(::new("scripts/skills/effects/hd_reload_disorientation_effect"));
		return __original(_user, _targetTile);
	}
});
