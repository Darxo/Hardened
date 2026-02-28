// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/sand_golem", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();

		this.HD_onSizeChanged();	// just in case there are some effects coded into happening at the default size
	}}.onInit;

	q.grow = @(__original) function( _instant = false )
	{
		__original(_instant);
		this.HD_onSizeChanged();
	}

	q.shrink = @(__original) function( _instant = false )
	{
		__original(_instant);
		this.HD_onSizeChanged();
	}

	// Overwrite, because damage is now redirected/handled by hd_headless_effect
	q.onDamageReceived = @() function( _attacker, _skill, _hitInfo )
	{
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	q.onMovementStep = @(__original) function( _tile, _levelDifference )
	{
		if (_tile.IsVisibleForPlayer)
		{
			return __original(_tile, _levelDifference);
		}
		else
		{
			// Vanilla Fix: Stop Sand Golems from producing sand while moving when the tile is not visible to the player
			return this.actor.onMovementStep(_tile, _levelDifference);
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.m.Variant = ::Math.rand(1, 2);
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_golem_body_0" + this.m.Variant + "_small");
		body.varySaturation(0.2);
		body.varyColor(0.06, 0.06, 0.06);
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.45;
		this.setSpriteOffset("status_rooted", this.createVec(-4, 7));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.SandGolem);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/golem_racial"));
		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_man_of_steel"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/headbutt_skill"));
		this.getSkills().add(::new("scripts/skills/actives/merge_golem_skill"));
		this.getSkills().add(::new("scripts/skills/actives/throw_golem_skill"));
	}

	// This is called once after and whenever this character grows or shrinks
	q.HD_onSizeChanged <- function()
	{
		local baseProp = this.getBaseProperties();
		switch (this.m.Size)
		{
			case 1:
			{
				baseProp.setValues(::Const.Tactical.Actor.SandGolem);
				this.getSkills().removeByID("perk.rf_marksmanship");
				this.getSkills().removeByID("perk.stalwart");
				break;
			}
			case 2:
			{
				baseProp.setValues(::Const.Tactical.Actor.HD_SandGolemMedium);
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_marksmanship"));
				this.getSkills().add(::new("scripts/skills/perks/perk_stalwart"));
				break;
			}
			case 3:
			{
				baseProp.setValues(::Const.Tactical.Actor.HD_SandGolemHigh);
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_marksmanship"));
				this.getSkills().add(::new("scripts/skills/perks/perk_stalwart"));

				break;
			}
		}

		// Regenerate all armor
		baseProp.Armor[0] = baseProp.ArmorMax[0];
	}
});
