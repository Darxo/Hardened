::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_zombie_orc_young", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ResurrectionChance = 100;	// Reforged: 66

		// Zombie Orcs use the same gear as their living counterparts
		local orcArmory = ::new("scripts/entity/tactical/enemies/orc_young");
		this.m.ChanceForNoChest = orcArmory.m.ChanceForNoChest;
		this.m.ChestWeightedContainer = orcArmory.m.ChestWeightedContainer;
		this.m.ChanceForNoHelmet = orcArmory.m.ChanceForNoHelmet;
		this.m.HelmetWeightedContainer = orcArmory.m.HelmetWeightedContainer;
		this.m.ChanceForNoWeapon = orcArmory.m.ChanceForNoWeapon;
		this.m.WeaponWeightContainer = orcArmory.m.WeaponWeightContainer;
		this.m.ChanceForNoOffhand = orcArmory.m.ChanceForNoOffhand;
		this.m.OffhandWeightContainer = orcArmory.m.OffhandWeightContainer;
	}

// New Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_ZombieOrcYoung);

		// Generic Effects

		// Generic Perks

		// Generic Actives
	}
});
