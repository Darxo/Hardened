// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/unhold_frost", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

// Hardened Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites = @() function()
	{
		this.m.Items.getAppearance().Body = "bust_unhold_body_01";
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_unhold_body_01");
		body.varySaturation(0.1);
		body.varyColor(0.04, 0.04, 0.04);
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_unhold_01_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_unhold_head_01");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		this.addSprite("helmet");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @() function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.UnholdFrost);
		b.IsImmuneToRotation = true;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/unhold_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_stalwart"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battering_ram"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_killing_frenzy"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/sweep_skill"));
		this.getSkills().add(::new("scripts/skills/actives/sweep_zoc_skill"));
		this.getSkills().add(::new("scripts/skills/actives/fling_back_skill"));
		this.getSkills().add(::new("scripts/skills/actives/unstoppable_charge_skill"));
	}
});
