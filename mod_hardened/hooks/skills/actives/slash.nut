::Hardened.HooksMod.hook("scripts/skills/actives/slash", function(q) {
	q.create = @(__original) function()
	{
		__original();

	// Reforged
		this.m.MeleeSkillAdd = 0;	// Reforged: 5
	}
});
