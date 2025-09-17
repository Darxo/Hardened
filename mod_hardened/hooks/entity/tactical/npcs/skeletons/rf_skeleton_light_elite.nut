// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_skeleton_light_elite", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/ancient/ancient_mail"],
			[12, "scripts/items/armor/ancient/ancient_double_layer_mail"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/ancient/ancient_household_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/ancient/broken_ancient_sword"],
			[12, "scripts/items/weapons/ancient/falx"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/ancient/coffin_shield"],
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
		b.setValues(::Const.Tactical.Actor.RF_SkeletonLightElite);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_one_with_the_shield"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
