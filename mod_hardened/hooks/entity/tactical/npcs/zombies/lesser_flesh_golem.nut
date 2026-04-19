// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lesser_flesh_golem", function(q) {
	q.create = @(__original) function()
	{
		__original();
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.addSprite("socket").setBrush("bust_base_undead");
		this.m.Items.getAppearance().Body = "bust_flesh_golem_body_01";

		local body = this.addSprite("body");
		body.setBrush("bust_flesh_golem_body_01");
		body.varySaturation(0.1);
		body.varyColor(0.09, 0.09, 0.09);

		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_flesh_golem_body_01_injured");
		this.addSprite("armor");

		local head = this.addSprite("head");
		head.setBrush("bust_flesh_golem_head_0" + ::Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		this.addSprite("helmet");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.LesserFleshGolem);
		this.m.ActionPointCosts = ::Const.DefaultMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/flesh_golem_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		this.getSkills().add(::new("scripts/skills/perks/perk_fast_adaption"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_menacing"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));

		// Generic Actives
	}
});
