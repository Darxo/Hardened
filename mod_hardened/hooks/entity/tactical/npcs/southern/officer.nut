// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/officer", function(q) {
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
		this.getSprite("socket").setBrush("bust_base_southern");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Officer);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_poise"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::Reforged.new("scripts/skills/perks/perk_rally_the_troops", function(o) {
			o.m.ActionPointCost = 3;
		}));
		this.getSkills().add(::new("scripts/skills/perks/perk_inspiring_presence"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_shield_sergeant"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_the_rush_of_battle"));
	}
});
