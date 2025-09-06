// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/hyena", function(q) {
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
		body.setBrush("bust_hyena_0" + this.Math.rand(1, 3));
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);

		local head = this.addSprite("head");
		head.setBrush("bust_hyena_0" + this.Math.rand(1, 3) + "_head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;

		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_hyena_injured");

		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Hyena);
		b.IsAffectedByNight = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/hd_bite_reach"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
		this.getSkills().add(::new("scripts/skills/perks/perk_relentless"));
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/hyena_bite_skill"));
	}
});
