::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_flail_2h", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.RegularDamage = 65; 		// Vanilla: 50
		this.m.RegularDamageMax = 100; 	// Vanilla: 100

		this.m.Reach = 4;	// In Reforged this is 5
	}
});
