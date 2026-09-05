::Hardened.HooksMod.hook("scripts/items/armor/barbarians/unhold_armor_light", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 50; 		// Vanilla: 35
	}
});
