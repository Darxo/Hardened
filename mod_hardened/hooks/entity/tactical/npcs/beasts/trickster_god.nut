// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/trickster_god", function(q) {
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
		this.addSprite("socket").setBrush("bust_base_beasts");

		local body = this.addSprite("body");
		body.setBrush("bust_trickster_god_body_01");

		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_trickster_god_01_injured");

		local head = this.addSprite("head");
		head.setBrush("bust_trickster_god_head_01");

		local frenzyEyes = this.addSprite("HD_frenzy_eyes");
		frenzyEyes.setBrush("zombie_rage_eyes");
		frenzyEyes.Alpha = 200;
		frenzyEyes.Scale = 1.2;
		this.setSpriteOffset("HD_frenzy_eyes", ::createVec(-22, -3));
		this.setSpriteRenderToTexture("HD_frenzy_eyes", false);		// The offset does not show up correctly in the turn sequence bar, so we just disable the sprite there

		this.addDefaultStatusSprites();

		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.setSpriteOffset("status_stunned", this.createVec(-32, 30));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.TricksterGod);
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToPoison = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;

		this.m.ActionPointCosts = this.Const.ImmobileMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/trickster_god_racial"));
		this.getSkills().add(::new("scripts/skills/special/hd_frenzy_eyes_manager"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_battering_ram"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_stalwart"));
		this.getSkills().add(::new("scripts/skills/perks/perk_underdog"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_decisive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));

		this.getSkills().add(::new("scripts/skills/perks/perk_hd_brace_for_impact"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/teleport_skill"));
		this.getSkills().add(::new("scripts/skills/actives/gore_skill"));
		this.getSkills().add(::new("scripts/skills/actives/hd_trickster_sweep_zoc_skill"));
		this.getSkills().add(::new("scripts/skills/actives/hd_trickster_sweep_skill"));
	}
});
