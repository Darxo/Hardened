::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/building", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.HD_DamagedConditionChance = 70;
		this.m.HD_DamagedConditionMin = 0.3;
	}
});
