::Hardened.HooksMod.hook("scripts/skills/special/rf_polearm_adjacency", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Long range melee attacks are harder to use in a crowded environment. Any melee attack with a maximum range of 2 or more tiles has its hit chance reduced for each adjacent character.";

		this.m.MeleeSkillModifierPerAlly = -5;	// In Reforged this is 0
		this.m.NumAlliesToIgnore = 2;	// In Reforged this is 0
	}
});
