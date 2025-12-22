::Hardened.HooksMod.hook("scripts/skills/actives/rf_sword_thrust_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

	// Reforged
		this.m.MeleeSkillAdd = 0;	// Reforged: 20
	}
});
