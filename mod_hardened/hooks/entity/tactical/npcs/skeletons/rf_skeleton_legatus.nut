// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_skeleton_legatus", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.rf_skeleton_commander.onInit();
	}}.onInit;

// Hardened Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites = @(__original) function()
	{
		__original();
		this.getSprite("rf_cape").setBrush("rf_ancient_cape");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_SkeletonLegatus);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_legatus"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_decisive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_cleaver"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_sanguinary"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_mauler"));
	}
});
