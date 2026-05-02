::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_draugr_shaman", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/rf_draugr/rf_draugr_white_bear_fur_mantle"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_wolf_fur_mantle"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[24, "scripts/items/helmets/rf_draugr/rf_draugr_skull_headdress"],	// Twice as likely because it has 2 variations
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_white_bear_headpiece"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_wolf_headpiece"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/rf_draugr/rf_draugr_shaman_staff"],
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
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_DraugrShaman);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/rf_barrow_chant_effect"));
		this.getSkills().add(::new("scripts/skills/effects/rf_unnerving_presence_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/rf_ancestral_summons_skill"));
	}
});
