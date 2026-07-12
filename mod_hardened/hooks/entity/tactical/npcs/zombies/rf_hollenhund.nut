::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_hollenhund", function(q) {
	q.m.BodyAlphaMin = 180;		// Reforged: 145
	q.m.BodyAlphaMax = 200;		// Reforged: 255

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
		this.setRenderCallbackEnabled(true);
		local bodyBrushName = "bust_rf_hollenhund_0" + this.m.Variant;

		this.m.Items.getAppearance().Body = bodyBrushName;
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("fog").setBrush("bust_ghost_fog_02");

		local blur_1 = this.addSprite("blur_1");
		blur_1.setBrush(bodyBrushName);
		blur_1.Alpha = this.m.BodyBlurAlpha;

		local body = this.addSprite("body");
		body.setBrush(bodyBrushName);
		body.varyColor(0.1, 0.1, 0.1);
		body.Alpha = ::Math.rand(this.m.BodyAlphaMin, this.m.BodyAlphaMax);

		blur_1.Saturation = body.Saturation;
		blur_1.Color = body.Color;

		local injury = this.addSprite("injury");
		injury.setBrush("bust_rf_hollenhund_01_injured");
		injury.Alpha = body.Alpha;
		injury.Visible = false;

		local head = this.addSprite("head");
		head.setBrush(bodyBrushName);
		head.varyColor(0.1, 0.1, 0.1);
		head.Visible = false;

		local blur = [
			"bust_rf_hollenhund_spirit_01",
			"bust_rf_hollenhund_spirit_02",
			"bust_rf_hollenhund_spirit_03"
		];

		local blur_2 = this.addSprite("blur_2");
		blur_2.setBrush(blur.remove(::Math.rand(0, blur.len() - 1)));
		blur_2.varySaturation(0.25);
		blur_2.varyColor(0.2, 0.2, 0.2);

		local blur_3 = this.addSprite("blur_3");
		blur_3.setBrush(blur.remove(::Math.rand(0, blur.len() - 1)));
		blur_2.varySaturation(0.25);
		blur_2.varyColor(0.2, 0.2, 0.2);

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", ::createVec(-5, -5));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.m.BaseProperties;
		b.setValues(::Const.Tactical.Actor.RF_Hollenhund);

		this.m.ActionPointCosts = ::Const.SameMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/ghost_racial"));
		this.getSkills().add(::new("scripts/skills/racial/skeleton_racial"));
		this.getSkills().add(::new("scripts/skills/effects/hd_grave_chill_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/rf_ethereal_bite_skill"));
	}
});
