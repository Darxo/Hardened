// We wipe many vanilla functions with the goal to de-couple the tail from the head
::Hardened.wipeClass("scripts/entity/tactical/enemies/lindwurm_tail", [
	"create",
	"onDeath",
	"getOverlayImage",
	"playAttackSound",
	"getIdealRange",
	"getBody",
	"getWorldTroop",
]);

// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lindwurm_tail", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();
		if (this.m.ParentID != 0) this.m.Body = ::Tactical.getEntityByID(this.m.ParentID);

		this.m.Name += " Tail";

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		__original(_killer, _skill, _tile, _fatalityType);
		if (!::MSU.isNull(this.getBody()) && this.getBody().isAlive() && !this.getBody().isDying())
		{
			this.getBody().getSkills().add(::new("scripts/skills/injury/hd_missing_tail"));
		}

		if (_tile != null)
		{
			local corpse = _tile.Properties.get("Corpse");
			corpse.CorpseName = "A Lindwurm Tail";
		}
	}

	// Overwrite, because we de-couple lindwurm tail from its Head
	q.kill = @() function( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		this.actor.kill(_killer, _skill, _fatalityType, _silent);

		if (!::MSU.isNull(this.m.Body) && this.m.Body.isAlive() && !this.m.Body.isDying())
		{
			this.m.Body = null;
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_lindwurm_tail_01");
		body.varySaturation(0.2);
		body.varyColor(0.08, 0.08, 0.08);

		local head = this.addSprite("head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;

		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_lindwurm_tail_01_injured");

		this.addSprite("body_blood");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.HD_LindwurmTail);
		b.IsMovable = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/hd_lindwurm_tail_racial"));	// Unlike the normal racial, this one does not grant immunity to stun/root
		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
		this.getSkills().add(::new("scripts/skills/effects/hd_unworthy_effect"));	// Only the head provides experience on a kill

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::Reforged.new("scripts/skills/perks/perk_rf_sweeping_strikes", function(o) {
			o.m.RequiredItemType = null;
		}));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/tail_slam_skill"));
		this.getSkills().add(::new("scripts/skills/actives/tail_slam_big_skill"));
		this.getSkills().add(::new("scripts/skills/actives/tail_slam_split_skill"));
		this.getSkills().add(::new("scripts/skills/actives/tail_slam_zoc_skill"));
		this.getSkills().add(::new("scripts/skills/actives/move_tail_skill"));
	}
});
