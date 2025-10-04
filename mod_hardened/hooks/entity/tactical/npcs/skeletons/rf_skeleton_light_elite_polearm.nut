// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_skeleton_light_elite_polearm", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/ancient/broken_bladed_pike"],
		]);

		this.m.OffhandWeightContainer = null;
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.skeleton.onInit();
	}}.onInit;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	// Overwrite, because we inherit from rf_skeleton_light_elite but dont want to reuse their skills and perks
	q.HD_onInitStatsAndSkills = @() function()
	{
		this.skeleton.HD_onInitStatsAndSkills();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.HD_SkeletonLightElitePolearm);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
	}
});
