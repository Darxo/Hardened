// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/goblin", function(q) {
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
		this.addSprite("socket").setBrush("bust_base_goblins");
		this.getItems().getAppearance().Body = "bust_goblin_01_body";
		local quiver = this.addSprite("quiver");
		quiver.Visible = false;
		local body = this.addSprite("body");
		body.setBrush("bust_goblin_01_body");
		body.varySaturation(0.1);
		body.varyColor(0.07, 0.07, 0.09);
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_goblin_01_body_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_goblin_01_head_injured");
		this.addSprite("helmet");
		this.addSprite("helmet_damage");
		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.GoblinFighter);
		b.IsFleetfooted = true;		// 50% less fatigue cost for footwork and rotation

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/captain_effect"));
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(::new("scripts/skills/racial/rf_goblin_racial"));
		this.getSkills().add(::new("scripts/skills/racial/hd_goblin_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
		this.getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		this.getSkills().add(::new("scripts/skills/perks/perk_quick_hands"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand"));
		this.getSkills().add(::new("scripts/skills/actives/wake_ally_skill"));
	}
});
