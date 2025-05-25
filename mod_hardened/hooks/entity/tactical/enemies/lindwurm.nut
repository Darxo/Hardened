::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lindwurm", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_exude_confidence"));
	}

	q.onMovementFinish = @(__original) function( _tile )
	{
		__original( _tile );

		local tail = this.m.Tail;
		if (!::MSU.isNull(tail) && tail.isAlive() && !tail.isDying())
		{
			local distanceToTail = this.getTile().getDistanceTo(tail.getTile());

			// If the Head moves away from the tail, it will cleans root and stunn effects on the tail
			if (distanceToTail != 1)
			{
				local removedRootEffect = ::Const.Tactical.Common.removeRooted(tail);
				if (removedRootEffect != null)
				{
					::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(tail) + " breaks free");
				}

				if (tail.getCurrentProperties().IsStunned)
				{
					::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(tail) + " is no longer stunned");
					tail.getSkills().removeByID("effects.sleeping");
					tail.getSkills().removeByID("effects.stunned");
					tail.getSkills().removeByID("effects.horrified");
				}
			}
		}
	}

// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.rf_formidable_approach");
		this.getSkills().removeByID("perk.rf_survival_instinct");
	}
});
