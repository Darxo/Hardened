::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_zombie_orc_berserker", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ResurrectionChance = 100;	// Reforged: 80

		// Zombie Orcs use the same gear as their living counterparts
		local orcArmory = ::new("scripts/entity/tactical/enemies/orc_berserker");
		this.m.ChanceForNoChest = orcArmory.m.ChanceForNoChest;
		this.m.ChestWeightedContainer = orcArmory.m.ChestWeightedContainer;
		this.m.ChanceForNoHelmet = orcArmory.m.ChanceForNoHelmet;
		this.m.HelmetWeightedContainer = orcArmory.m.HelmetWeightedContainer;
		this.m.ChanceForNoWeapon = orcArmory.m.ChanceForNoWeapon;
		this.m.WeaponWeightContainer = orcArmory.m.WeaponWeightContainer;
		this.m.ChanceForNoOffhand = orcArmory.m.ChanceForNoOffhand;
		this.m.OffhandWeightContainer = orcArmory.m.OffhandWeightContainer;
	}

	// Overwrite, because we dont want to add extra perks in this base function
	q.onInit = @() function()
	{
		this.rf_zombie_orc.onInit();
	}

// Reforged Functions
	// Overwrite, because we dont want to add any of the reforged perks and skills
	q.onSpawned = @() function()
	{
	}

// New Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_ZombieOrcBerserker);

		// Generic Effects

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_battering_ram"));

		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));

		// Generic Actives
	}
});
