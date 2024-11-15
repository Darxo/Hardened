::Hardened.HooksMod.hook("scripts/skills/actives/throw_holy_water", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// This skill is no longer considered an attack. This flag didn't make sense in vanilla anyways
	}
});

