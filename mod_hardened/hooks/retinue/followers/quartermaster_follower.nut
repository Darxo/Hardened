::Hardened.HooksMod.hook("scripts/retinue/followers/quartermaster_follower", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Effects[0] = ::MSU.String.replace(this.m.Effects[0], "100", "150");
		this.m.Effects[1] = ::MSU.String.replace(this.m.Effects[1], "50", "100");
	}

	// Overwrite, because Vanilla overwrites existing values instead of adding to them
	q.onUpdate = @() function()
	{
		::World.Assets.m.AmmoMaxAdditional += 150;			// In Vanilla this is 100
		::World.Assets.m.MedicineMaxAdditional += 100;		// In Vanilla this is 50
		::World.Assets.m.ArmorPartsMaxAdditional += 100;	// In Vanilla this is 50
	}
});
