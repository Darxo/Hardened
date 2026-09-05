::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/unhold_helmet_light", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 50; 		// Vanilla: 35
	}
});
