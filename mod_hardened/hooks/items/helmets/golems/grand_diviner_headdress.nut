::Hardened.HooksMod.hook("scripts/items/helmets/golems/grand_diviner_headdress", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionMax = 100; 		// Vanilla: 75; Reforged: 90
	}
});
