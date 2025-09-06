// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/alp", function(q) {
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
		body.setBrush("bust_alp_body_01");
		body.varySaturation(0.2);
		local head = this.addSprite("head");
		head.setBrush("bust_alp_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.setBrush("bust_alp_01_injured");
		injury.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", this.createVec(0, 10));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Alp);
		// b.Initiative += this.Math.rand(0, 55);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/alp_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/sleep_skill"));
		this.getSkills().add(::new("scripts/skills/actives/nightmare_skill"));
		this.getSkills().add(::new("scripts/skills/actives/alp_teleport_skill"));
	}
});
