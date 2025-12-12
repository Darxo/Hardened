// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/hexe", function(q) {
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
		body.setBrush("bust_hexen_body_0" + this.Math.rand(1, 3));
		body.varySaturation(0.1);
		body.varyColor(0.05, 0.05, 0.05);
		local charm_body = this.addSprite("charm_body");
		charm_body.setBrush("bust_hexen_charmed_body_01");
		charm_body.Visible = false;
		local charm_armor = this.addSprite("charm_armor");
		charm_armor.setBrush("bust_hexen_charmed_dress_0" + this.Math.rand(1, 3));
		charm_armor.Visible = false;
		local head = this.addSprite("head");
		head.setBrush("bust_hexen_head_0" + this.Math.rand(1, 3));
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local charm_head = this.addSprite("charm_head");
		charm_head.setBrush("bust_hexen_charmed_head_0" + this.Math.rand(1, 2));
		charm_head.Visible = false;
		local injury = this.addSprite("injury");
		injury.setBrush("bust_hexen_01_injured");
		local hair = this.addSprite("hair");
		hair.setBrush("bust_hexen_hair_0" + this.Math.rand(1, 4));
		local charm_hair = this.addSprite("charm_hair");
		charm_hair.setBrush("bust_hexen_charmed_hair_0" + this.Math.rand(1, 5));
		charm_hair.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Hexe);
		b.TargetAttractionMult = 3.0;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/hd_hexe_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_recover"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_soul_link"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/charm_skill"));
		this.getSkills().add(::new("scripts/skills/actives/hex_skill"));
		this.getSkills().add(::new("scripts/skills/actives/fake_drink_night_vision_skill"));
	}
});
