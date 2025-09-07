// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/orc_warlord", function(q) {
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
		this.m.Items.getAppearance().Body = "bust_orc_04_body";
		this.addSprite("socket").setBrush("bust_base_orcs");
		local body = this.addSprite("body");
		body.setBrush("bust_orc_04_body");
		body.varyColor(0.1, 0.1, 0.1);
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_04_body_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_orc_04_head_01");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_04_head_injured");
		this.addSprite("helmet");
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_orc_04_body_bloodied");
		body_blood.Visible = false;
		this.addDefaultStatusSprites();
		this.setSpriteOffset("arms_icon", this.createVec(-8, 0));
		this.setSpriteOffset("shield_icon", this.createVec(-5, 0));
		this.setSpriteOffset("stunned", this.createVec(0, 10));
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(0, 16));
		this.setSpriteOffset("status_stunned", this.createVec(-5, 30));
		this.setSpriteOffset("arrow", this.createVec(-5, 30));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.OrcWarlord);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_orc_racial"));
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(::new("scripts/skills/effects/captain_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_berserk"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));

		this.getSkills().add(::new("scripts/skills/perks/perk_battering_ram"));
		this.getSkills().add(::new("scripts/skills/perks/perk_stalwart"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_menacing"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bulwark"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));

		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_axe"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_dismantle"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_death_dealer"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand_orc"));
		this.m.Skills.add(this.new("scripts/skills/actives/line_breaker"));
		this.m.Skills.add(this.new("scripts/skills/actives/warcry"));
	}
});
