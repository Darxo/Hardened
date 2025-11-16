::Hardened.HooksMod.hook("scripts/retinue/followers/quartermaster_follower", function(q) {
	// Public
	q.m.HD_RequiredCartUpgrades <- 2;	// This many cart upgrades are required to unlock this retinue
	q.m.HD_AmmoCapacityModifier <- 100;
	q.m.HD_ArmorPartsCapacityModifier <- 100;
	q.m.HD_MedicineCapacityModifier <- 100;

	q.create = @(__original) function()
	{
		__original();
		this.m.Cost = 1500;		// Vanilla: 3000
		this.m.Effects = [
			"+" + this.m.HD_AmmoCapacityModifier + " Capacity for Ammo",
			"+" + this.m.HD_ArmorPartsCapacityModifier + " Capacity for Tools and Supplies",
			"+" + this.m.HD_MedicineCapacityModifier + " Capacity for Medicine",
		];
	}

	// Overwrite, because Vanilla overwrites existing values instead of adding to them
	q.onUpdate = @() function()
	{
		::World.Assets.m.AmmoMaxAdditional += this.m.HD_AmmoCapacityModifier;				// Vanilla: 100
		::World.Assets.m.ArmorPartsMaxAdditional += this.m.HD_ArmorPartsCapacityModifier;	// Vanilla: 50
		::World.Assets.m.MedicineMaxAdditional += this.m.HD_MedicineCapacityModifier;		// Vanilla: 50
	}

	// Overwrite, because we introduce a completely different custom condition
	q.onEvaluate = @() function()
	{
		this.m.Requirements[0].IsSatisfied = ::World.Retinue.getInventoryUpgrades() >= this.m.HD_RequiredCartUpgrades;
		this.m.Requirements[0].Text = "Upgrade your Cart " + ::World.Retinue.getInventoryUpgrades() + "/" + this.m.HD_RequiredCartUpgrades + " times";
	}
});
