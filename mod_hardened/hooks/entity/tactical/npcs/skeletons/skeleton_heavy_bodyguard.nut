// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_heavy_bodyguard", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/ancient/khopesh"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/ancient/tower_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.skeleton.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
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
		b.setValues(::Const.Tactical.Actor.HD_SkeletonHeavyBodyguard);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_exploit_opening"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_line_breaker"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_cleaver"));

		this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_sanguinary"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_mauler"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor = ::MSU.Class.WeightedContainer([
				[1.0, "scripts/items/armor/ancient/ancient_plate_harness"],
				[1.0, "scripts/items/armor/ancient/ancient_plated_scale_hauberk"]
			]).roll();

			this.m.Items.equip(::new(armor));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head))
		{
			this.m.Items.equip(::new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));
		}
	}
});
