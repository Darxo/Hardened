// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_light", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/ancient/broken_ancient_sword"],
			[12, "scripts/items/weapons/ancient/falx"],
		]);

		this.m.ChanceForNoOffhand = 33;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/ancient/auxiliary_shield"],
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

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.SkeletonLight);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		if (this.Math.rand(1, 100) < 75)
		{
			this.getItems().equip(::new("scripts/items/armor/ancient/ancient_ripped_cloth"));
		}

		if (this.Math.rand(1, 100) < 75)
		{
			this.getItems().equip(::new("scripts/items/helmets/ancient/ancient_household_helmet"));
		}
	}
});
