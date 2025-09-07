// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/unhold", function(q) {
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
		this.m.Items.getAppearance().Body = "bust_unhold_body_02";
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_unhold_body_02");
		body.varySaturation(0.1);
		body.varyColor(0.09, 0.09, 0.09);
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_unhold_02_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_unhold_head_02");
		if (::Math.rand(1, 100) <= 5) head.setBrush("bust_rf_unhold_head_smiling");	// Reforged adds a chance to have smiling unhold face as head sprite
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		this.addSprite("helmet");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Unhold);
		b.IsImmuneToRotation = true;

		// Generic Effects
		this.getSkills().add(::Reforged.new("scripts/skills/racial/unhold_racial", function(o) {
			o.m.HD_RecoveredHitpointPct = 0.1;	// Reforged: 0.15
		}));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_stalwart"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battering_ram"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/sweep_skill"));
		this.getSkills().add(::new("scripts/skills/actives/sweep_zoc_skill"));
		this.getSkills().add(::new("scripts/skills/actives/fling_back_skill"));
		this.getSkills().add(::new("scripts/skills/actives/unstoppable_charge_skill"));
	}
});
