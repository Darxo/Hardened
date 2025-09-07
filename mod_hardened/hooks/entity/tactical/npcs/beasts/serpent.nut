// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/serpent", function(q) {
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
		this.m.Variant = this.Math.rand(1, 2);
		body.setBrush("bust_snake_0" + this.m.Variant + "_head_0" + this.Math.rand(1, 2));
		body.varySaturation(0.1);
		body.varyColor(0.1, 0.1, 0.1);
		body.varyBrightness(0.1);

		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_snake_injury");

		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 20));
		this.setSpriteOffset("status_stunned", this.createVec(-35, 20));
		this.setSpriteOffset("arrow", this.createVec(0, 20));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Serpent);
		// b.Initiative += this.Math.rand(0, 50);
		b.IsAffectedByNight = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/serpent_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));

		this.getSkills().add(::new("scripts/skills/perks/perk_relentless"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/serpent_bite_skill"));
		this.getSkills().add(::new("scripts/skills/actives/serpent_hook_skill"));
	}
});
