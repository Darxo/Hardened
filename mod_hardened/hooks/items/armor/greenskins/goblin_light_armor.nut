::Hardened.HooksMod.hook("scripts/items/armor/greenskins/goblin_light_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 50; 		// Vanilla: 45
	}
});
