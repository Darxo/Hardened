// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_boss", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/legendary/lightbringer_sword"],
		]);
	}

	// Overwrite, because we completely replace Vanilla stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.addSprite("socket").setBrush("bust_base_undead");

		local body = this.addSprite("body");
		body.setBrush("bust_ghost_knight_body_01");

		local head = this.addSprite("head");
		head.setBrush("bust_ghost_knight_01_head_01");

		this.addDefaultStatusSprites();
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.ZombieBoss);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_zombie_racial"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_wear_them_down"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_wear_them_down"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_anchor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));
		this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));
		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
		this.getSkills().add(::Reforged.new("scripts/skills/perks/perk_rf_mentor", function(o) {
			o.m.MaxStudents = 2;
		}));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/zombie_bite"));
	}
});
