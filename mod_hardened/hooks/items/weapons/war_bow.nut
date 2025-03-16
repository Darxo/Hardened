::Hardened.HooksMod.hook("scripts/items/weapons/war_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.StaminaModifier = -8;	// In Vanilla this is -6
		this.m.FatigueOnSkillUse = 2;	// In Vanilla this is 0
	}
});
