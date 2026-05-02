::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_draugr_huskarl", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 170
			[12, "scripts/items/armor/rf_draugr/rf_draugr_crude_metal_armor"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_leather_and_bones_harness"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_metal_armor"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_skull_and_bones_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_heavy_horned_helmet"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_horned_helmet"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_light_horned_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[20, "scripts/items/weapons/rf_draugr/rf_draugr_battle_axe"],
			[16, "scripts/items/weapons/rf_draugr/rf_draugr_voulge"],
			[12, "scripts/items/weapons/rf_draugr/rf_draugr_axe"],
			[12, "scripts/items/weapons/rf_draugr/rf_draugr_cleaver"],
			[12, "scripts/items/weapons/rf_draugr/rf_draugr_sword"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/rf_draugr/rf_draugr_round_shield"],
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

		if (this.getMainhandItem().isItemType(::Const.Items.ItemType.TwoHanded))
		{
			if (this.getMainhandItem().isWeaponType(::Const.Items.WeaponType.Axe))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
			}
			else if (this.getMainhandItem().isWeaponType(::Const.Items.WeaponType.Cleaver))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_head_hunter"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_sanguinary"));
			}
		}
		else
		{
			this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));
			this.getSkills().add(::new("scripts/skills/perks/perk_hd_one_with_the_shield"));
			this.getSkills().add(::new("scripts/skills/perks/perk_rf_shield_sergeant"));
		}
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_DraugrHuskarl);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/rf_unnerving_presence_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_menacing"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_brace_for_impact"));
		// Generic Actives
	}
});
