// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/spider", function(q) {
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
		this.setRenderCallbackEnabled(true);
		this.addSprite("socket").setBrush("bust_base_beasts");

		local legs_back = this.addSprite("legs_back");
		legs_back.setBrush("bust_spider_legs_back");

		local body = this.addSprite("body");
		body.setBrush("bust_spider_body_0" + ::Math.rand(1, 4));
		body.varySaturation(0.3);
		body.varyColor(0.1, 0.1, 0.1);
		body.varyBrightness(0.1);

		local legs_front = this.addSprite("legs_front");
		legs_front.setBrush("bust_spider_legs_front");
		legs_front.Color = body.Color;
		legs_front.Saturation = body.Saturation;
		legs_back.Color = body.Color;
		legs_back.Saturation = body.Saturation;

		local head = this.addSprite("head");
		head.setBrush("bust_spider_head_01");
		head.Color = body.Color;
		head.Saturation = body.Saturation;

		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_spider_01_injured");

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(7, 10));
		this.setSpriteOffset("status_stunned", this.createVec(0, -20));
		this.setSpriteOffset("arrow", this.createVec(0, -20));
		this.setSize(::Math.rand(70, 90) * 0.01);
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Spider);
		this.m.MaxTraversibleLevels = 3;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/spider_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/spider_bite_skill"));
		this.getSkills().add(::new("scripts/skills/actives/web_skill"));
		this.getSkills().add(::new("scripts/skills/actives/wake_ally_skill"));
	}
});
