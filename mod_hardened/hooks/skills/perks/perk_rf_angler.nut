::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_angler", function(q) {
	q.m.MaxRangeModifier <- 1;	// Range Modifier for Throw Net skill

	q.create = @(__original) function()
	{
		__original();
		this.m.BreakFreeAPCostMult = 1.0;	// This perk no longer increases the break free cost
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		foreach (skill in this.getContainer().m.Skills)
		{
			if (this.isSkillValid(skill))
			{
				skill.m.MaxRange += this.m.MaxRangeModifier;
			}
		}
	}

	q.onReallyAfterSkillExecuted = @(__original) function( _skill, _targetTile, _success )
	{
		__original(_skill, _targetTile, _success);
		if (_targetTile.IsOccupiedByActor && _skill.getID() == "actives.throw_net")
		{
			local targetEntity = _targetTile.getEntity();
			targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " has staggered " + ::Const.UI.getColorizedEntityName(targetEntity));
		}
	}

// MSU Events
q.onQueryTooltip <- function( _skill, _tooltip )
{
	if (this.isSkillValid(_skill))
	{
		_tooltip.push({
			id = 100,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Will [stagger|Skill+staggered_effect] the target"),
		});
	}
}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return (_skill.getID() == "actives.throw_net");
	}
});
