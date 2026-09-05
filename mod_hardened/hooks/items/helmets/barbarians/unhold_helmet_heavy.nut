::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/unhold_helmet_heavy", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 300; 		// Vanilla: 400
	}
});
