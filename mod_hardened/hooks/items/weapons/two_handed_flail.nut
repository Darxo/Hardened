::Hardened.HooksMod.hook("scripts/items/weapons/two_handed_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1800;			// Vanilla: 1400
		this.m.RegularDamage = 55; 		// Vanilla: 45
		this.m.RegularDamageMax = 90; 	// Vanilla: 90

		this.m.Reach = 4;		// In Reforged this is 5
	}
});
