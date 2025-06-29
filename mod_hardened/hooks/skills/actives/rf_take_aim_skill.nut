::Hardened.HooksMod.hook("scripts/skills/actives/rf_take_aim_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 3;		// Reforged: 2
		this.m.FatigueCost = 20;		// In Reforged this is 25
	}
});
