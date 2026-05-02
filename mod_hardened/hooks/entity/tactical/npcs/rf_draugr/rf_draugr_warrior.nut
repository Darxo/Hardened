::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_draugr_warrior", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 130 - 15
			[12, "scripts/items/armor/rf_draugr/rf_draugr_fur_mantle"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_hide_and_bones_shirt"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_pauldron_fur_armor"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_skull_and_plate_armor"],
			[12, "scripts/items/armor/rf_draugr/rf_draugr_skull_mantle"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_antler_headband"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_claw_headband"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_dentated_headband"],
			[12, "scripts/items/helmets/rf_draugr/rf_draugr_ritual_headpiece"],
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
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
			}
			else if (this.getMainhandItem().isWeaponType(::Const.Items.WeaponType.Cleaver))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_head_hunter"));
			}
		}
		else
		{
			this.getSkills().add(::new("scripts/skills/perks/perk_hd_one_with_the_shield"));
		}
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_DraugrWarrior);

		// Generic Effects

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));

		// Generic Actives
	}
});
