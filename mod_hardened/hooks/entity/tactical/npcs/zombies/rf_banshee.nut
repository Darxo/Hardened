::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_banshee", function(q) {
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
		// This is an exact Reforged copy (with slighty better formatting), because we want to split sprit and skill initiatilisation
		this.setRenderCallbackEnabled(true);

		local brushName = "bust_rf_banshee_01";
		this.m.Items.getAppearance().Body = brushName;
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("fog").setBrush("bust_ghost_fog_02");

		local body = this.addSprite("body");
		body.setBrush(brushName);
		body.varySaturation(0.25);
		body.varyColor(0.2, 0.2, 0.2);

		local head = this.addSprite("head");
		head.setBrush(brushName);
		head.varySaturation(0.25);
		head.varyColor(0.2, 0.2, 0.2);

		local blur_1 = this.addSprite("blur_1");
		blur_1.setBrush(brushName);
		blur_1.varySaturation(0.25);
		blur_1.varyColor(0.2, 0.2, 0.2);

		local blur_2 = this.addSprite("blur_2");
		blur_2.setBrush(brushName);
		blur_2.varySaturation(0.25);
		blur_2.varyColor(0.2, 0.2, 0.2);

		this.addDefaultStatusSprites();

		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", ::createVec(-5, -5));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		this.m.MaxTraversibleLevels = 3;

		// Tweak Base Properties
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.RF_Banshee);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/ghost_racial"));
		this.getSkills().add(::new("scripts/skills/effects/rf_whimpering_veil_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/ghastly_touch"));
		this.getSkills().add(::new("scripts/skills/actives/rf_wail_skill"));
	}
});
