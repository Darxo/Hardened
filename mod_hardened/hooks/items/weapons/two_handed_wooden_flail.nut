::Hardened.HooksMod.hook("scripts/items/weapons/two_handed_wooden_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 600;			// Vanilla: 500
		this.m.RegularDamage = 35; 		// Vanilla: 30
		this.m.RegularDamageMax = 65; 	// Vanilla: 60

		this.m.Reach = 4;		// In Reforged this is 5
	}
});
