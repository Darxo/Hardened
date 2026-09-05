::Hardened.HooksMod.hook("scripts/items/armor/barbarians/unhold_armor_heavy", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 300; 		// Vanilla: 400
	}
});
