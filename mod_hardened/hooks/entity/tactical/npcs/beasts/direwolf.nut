// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/direwolf", function(q) {
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
		body.setBrush("bust_direwolf_0" + ::Math.rand(1, 3));
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);

		local head = this.addSprite("head");
		head.setBrush("bust_direwolf_0" + ::Math.rand(1, 3) + "_head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;

		local head_frenzy = this.addSprite("head_frenzy");
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_direwolf_injured");

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
		b.setValues(::Const.Tactical.Actor.Direwolf);
		b.IsAffectedByNight = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/hd_bite_reach"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_from_all_sides"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_berserk"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/werewolf_bite"));
		this.getSkills().add(::new("scripts/skills/actives/recover_skill"));
		this.getSkills().add(::new("scripts/skills/actives/wake_ally_skill"));
	}
});
