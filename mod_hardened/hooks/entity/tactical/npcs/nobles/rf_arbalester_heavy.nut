// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_arbalester_heavy", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_military");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(this.Const.Tactical.Actor.RF_ArbalesterHeavy);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_crossbow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_through_the_ranks"));
		this.getSkills().add(::new("scripts/skills/perks/perk_bullseye"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_entrenched"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_steady_brace"));
	}
});
