::Hardened.HooksMod.hook("scripts/items/armor/greenskins/goblin_medium_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 70; 		// Vanilla: 55
	}
});
