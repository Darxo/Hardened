// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_knight_anointed", function(q) {
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
		b.setValues(::Const.Tactical.Actor.Knight);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_shield_expert"));
		this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_family_pride"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_exude_confidence"));
		this.getSkills().add(::Reforged.new("scripts/skills/perks/perk_rf_mentor", function(o) {
			o.m.MaxStudents = 2;
		}));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_the_rush_of_battle"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bulwark"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_pattern_recognition"));

		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_decisive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_underdog"));
	}
});
