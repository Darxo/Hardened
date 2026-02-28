// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/ghoul", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	q.grow = @(__original) function( _instant = false )
	{
		__original(_instant);

		// Remove perks added by reforged. Ideally we overwite
		this.getSkills().removeByID("perk.coup_de_grace");		// Reforged Perk
		this.getSkills().removeByID("perk.fearsome");			// Reforged Perk
		this.getSkills().removeByID("perk.rf_menacing");		// Reforged Perk

		// Vanilla Ghouls are implemented as 3 stages/sizes inside the same base ghoul object, so we need to manage changes to basestats and skills inside this grow function
		// Ghouls can only ever grow and never shrink, so we only need to manage it in one direction
		// Newly Spawned ghouls also call grow
		local b = this.getBaseProperties();
		if (this.m.Size == 2)
		{
			b.setValues(::Const.Tactical.Actor.HD_GhoulMedium);

			this.getSkills().removeByID("perk.rf_ghostlike");	// T1 Ghoul Perk

			this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		}
		else	// Size 3 or higher size
		{
			b.setValues(::Const.Tactical.Actor.HD_GhoulHigh);

			this.getSkills().removeByID("perk.rf_ghostlike");		// T1 Ghoul Perk
			this.getSkills().removeByID("perk.crippling_strikes");	// T2 Ghoul Perk

			this.getSkills().add(::new("scripts/skills/perks/perk_coup_de_grace"));
			this.getSkills().add(::new("scripts/skills/perks/perk_rf_fresh_and_furious"));

			this.getSkills().add(::new("scripts/skills/actives/swallow_whole_skill"));	// In Vanilla it always exists on them. We only add it on size 3 variants
		}
	}

	// Overwrite, because we don't multiply XP with size. Instead we assign new base XP values manually as the ghoul grows
	q.getXPValue = @() function()
	{
		return this.actor.getXPValue();
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_ghoul_body_01");
		body.varySaturation(0.25);
		body.varyColor(0.06, 0.06, 0.06);
		local head = this.addSprite("head");
		head.setBrush("bust_ghoul_head_01");
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		this.m.Head = ::Math.rand(1, 3);
		local injury = this.addSprite("injury");
		injury.setBrush("bust_ghoul_01_injured");
		injury.Visible = false;
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Ghoul);
		b.IsAffectedByNight = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/gruesome_feast_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_ghostlike"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/ghoul_claws"));
		this.getSkills().add(::new("scripts/skills/actives/gruesome_feast"));
	}
});
