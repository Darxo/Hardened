::Hardened.HooksMod.hook("scripts/items/helmets/greenskins/goblin_light_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 70; 		// Vanilla: 40
	}
});
