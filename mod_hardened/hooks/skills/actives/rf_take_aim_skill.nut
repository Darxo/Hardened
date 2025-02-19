::Hardened.HooksMod.hook("scripts/skills/actives/rf_take_aim_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 4;	// In Reforged this is 6
		this.m.FatigueCost = 20;	// In Reforged this is 25
	}
});
