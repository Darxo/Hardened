::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_draugr_thrall", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChanceForNoChest = 50;
		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 50
			[12, "scripts/items/armor/rf_draugr/rf_draugr_skull_wraps"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_leather_wraps"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_pauldron_armor"],
		]);

		this.m.ChanceForNoHelmet = 50;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_headband"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_headwrap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/barbarians/axehammer"],
			[12, "scripts/items/weapons/barbarians/blunt_cleaver"],
			[12, "scripts/items/weapons/barbarians/crude_axe"],
		]);
	}

	// Overwrite, because we implement our skills and perks via HD_onInitStatsAndSkills
	q.onInit = @() function()
	{
		this.rf_draugr.onInit();
	}

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we dont want to add any of the reforged perks and skills
	q.onSpawned = @() function()
	{
		this.rf_draugr.onSpawned();
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_DraugrThrall);

		// Generic Effects

		// Generic Perks

		// Generic Actives
	}
});
