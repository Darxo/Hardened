// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/wardog", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() function()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		local variant = this.Math.rand(1, 4);
		this.m.Items.getAppearance().Body = "bust_dog_01_body_0" + variant;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_dog_01_body_0" + variant);
		local armor = this.addSprite("armor");
		this.addSprite("head").setBrush("bust_dog_01_head_0" + variant);
		local closed_eyes = this.addSprite("closed_eyes");
		closed_eyes.setBrush("bust_dog_01_body_0" + variant + "_eyes_closed");
		closed_eyes.Visible = false;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_dog_01_injured");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.46;
		this.setSpriteOffset("status_rooted", this.createVec(8, -15));
		this.setSpriteOffset("status_stunned", this.createVec(0, -25));
		this.setSpriteOffset("arrow", this.createVec(0, -25));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Wardog);
		b.TargetAttractionMult = 0.1;
		// b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/hd_bite_reach"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		// this.getSkills().add(::new("scripts/skills/perks/perk_steel_brow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_wear_them_down"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/wardog_bite"));
	}
});
