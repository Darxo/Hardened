// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_medium_polearm", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/ancient/bladed_pike"],
		]);

		this.m.OffhandWeightContainer = null;
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
		b.setValues(::Const.Tactical.Actor.HD_SkeletonMediumPolearm);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_long_reach"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor = ::MSU.Class.WeightedContainer([
				[1, "scripts/items/armor/ancient/ancient_scale_harness"],
				[1, "scripts/items/armor/ancient/ancient_breastplate"],
			]).roll();

			this.m.Items.equip(::new(armor));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head))
		{
			this.m.Items.equip(::new("scripts/items/helmets/ancient/ancient_legionary_helmet"));
		}
	}
});
