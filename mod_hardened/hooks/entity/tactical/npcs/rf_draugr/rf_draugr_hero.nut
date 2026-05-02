::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_draugr_hero", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 230
			[12, "scripts/items/armor/rf_draugr/rf_draugr_decorated_metal_armor"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_horns_and_plate_armor"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_runic_metal_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_antler_helmet"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_decorated_nasal_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/rf_draugr/rf_draugr_greataxe"],
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
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_DraugrHero);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/rf_unnerving_presence_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_menacing"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_brace_for_impact"));

		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_death_dealer"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));

		// Generic Actives
	}
});
