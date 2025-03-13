::Hardened.wipeClass("scripts/entity/tactical/enemies/lindwurm_tail", [
	"create",
	"onInit",
	"onDeath",
	"getOverlayImage",
	"playAttackSound",
	"getIdealRange",
	"getBody",
	"getWorldTroop",
]);

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lindwurm_tail", function(q) {
	q.onInit = @(__original) function()
	{
		// Switcheroo to prevent the vanilla function from overwriting the ItemContainer, as Head and Tail are now fully separated
		local oldParentID = this.m.ParentID;
		this.m.ParentID = 0;
		__original();
		this.m.ParentID = oldParentID;

		if (this.m.ParentID != 0)	// This is also done by vanilla but accidentally skipped due to our switcheroo, so we must do it now manually
		{
			this.m.Body = ::Tactical.getEntityByID(this.m.ParentID);
		}

		local b = this.m.BaseProperties;
		b.Hitpoints *= 0.5;
		b.MeleeDefense *= 1.5;
		b.Bravery *= 0.5;

		this.m.Name += " Tail";

		this.getSkills().removeByID("racial.lindwurm");
		this.getSkills().add(::new("scripts/skills/racial/hd_lindwurm_tail_racial"));	// Unlike the normal racial, this one does not grant immunity to stun/root

		// Fix(Reforged): remove weapon type restriction as lindwurm tails wield no weapon
		this.getSkills().removeByID("perk.rf_sweeping_strikes");
		this.m.Skills.add(::Reforged.new("scripts/skills/perks/perk_rf_sweeping_strikes", function(o) {
			o.m.RequiredItemType = null;
		}));

		this.getSkills().removeByID("perk.fearsome");
		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
	}

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

	q.kill <- function( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		this.actor.kill(_killer, _skill, _fatalityType, _silent);

		if (!::MSU.isNull(this.m.Body) && this.m.Body.isAlive() && !this.m.Body.isDying())
		{
			this.m.Body = null;
		}
	}
});
