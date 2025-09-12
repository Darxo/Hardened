// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lindwurm", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
		this.setupTail();
	}}.onInit;

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_lindwurm_body_0" + this.Math.rand(1, 1));
		body.varySaturation(0.2);
		body.varyColor(0.08, 0.08, 0.08);
		local head = this.addSprite("head");
		head.setBrush("bust_lindwurm_head_0" + this.Math.rand(1, 1));
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_lindwurm_body_01_injured");
		local body_blood = this.addSprite("body_blood");
		body_blood.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.63;
		this.setSpriteOffset("status_rooted", this.createVec(0, 15));
		this.setSpriteOffset("status_stunned", this.createVec(-5, 30));
		this.setSpriteOffset("arrow", this.createVec(-5, 30));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Lindwurm);
		b.TargetAttractionMult = 0.1;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/lindwurm_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_menacing"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_exude_confidence"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/gorge_skill"));
	}

	q.setupTail <- function()
	{
		if (this.m.Tail != null) return;

		local myTile = this.getTile();
		local spawnTile;
		if (myTile.hasNextTile(::Const.Direction.NE) && myTile.getNextTile(::Const.Direction.NE).IsEmpty)
		{
			spawnTile = myTile.getNextTile(::Const.Direction.NE);
		}
		else if (myTile.hasNextTile(::Const.Direction.SE) && myTile.getNextTile(::Const.Direction.SE).IsEmpty)
		{
			spawnTile = myTile.getNextTile(::Const.Direction.SE);
		}
		else
		{
			for (local i = 0; i < 6; ++i)
			{
				if (!myTile.hasNextTile(i)) continue;
				if (!myTile.getNextTile(i).IsEmpty) continue;
				spawnTile = myTile.getNextTile(i);
				break;
			}
		}

		if (spawnTile != null)
		{
			this.m.Tail = this.WeakTableRef(this.Tactical.spawnEntity("scripts/entity/tactical/enemies/lindwurm_tail", spawnTile.Coords.X, spawnTile.Coords.Y, this.getID()));
			this.m.Tail.m.Body = this.WeakTableRef(this);
			this.m.Tail.getSprite("body").Color = body.Color;
			this.m.Tail.getSprite("body").Saturation = body.Saturation;
		}
	}
});
