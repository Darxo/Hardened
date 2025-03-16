::Hardened.HooksMod.hook("scripts/items/weapons/heavy_crossbow", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueOnSkillUse = 2;	// In Vanilla this is 0
	}
});
