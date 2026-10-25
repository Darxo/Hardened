::Hardened.HooksMod.hook("scripts/items/armor/greenskins/goblin_leader_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 120; 		// Vanilla: 180
	}
});
