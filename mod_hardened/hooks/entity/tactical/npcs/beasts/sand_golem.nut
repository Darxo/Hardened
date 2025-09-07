// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/sand_golem", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
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
		this.m.Variant = this.Math.rand(1, 2);
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_golem_body_0" + this.m.Variant + "_small");
		body.varySaturation(0.2);
		body.varyColor(0.06, 0.06, 0.06);
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.SandGolem);
		b.IsAffectedByNight = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToFire = true;
		b.IsAffectedByInjuries = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/golem_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_man_of_steel"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/headbutt_skill"));
		this.getSkills().add(::new("scripts/skills/actives/merge_golem_skill"));
		this.getSkills().add(::new("scripts/skills/actives/throw_golem_skill"));
	}
});
