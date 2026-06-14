::Hardened.HooksMod.hook("scripts/items/weapons/rf_two_handed_falchion", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.RegularDamage = 45;		// Reforged: 50
		this.m.Reach = 5;				// Reforged: 4
	}
});
