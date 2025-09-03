::Hardened.HooksMod.hook("scripts/skills/injury/dislocated_shoulder_injury", function(q) {
	q.m.ActionPointModifier <- 3;	// Action Point cost of all active skills is modified by this value

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 7 && entry.icon == "ui/icons/action_points.png")
			{
				entry.text = "All active skills cost " + ::MSU.Text.colorizeValue(this.m.ActionPointModifier, {AddSign = true, InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Action Points|Concept.ActionPoints]");
				break;
			}
		}

		return ret;
	}

	// Overwrite, because we want to disable the vanilla AP effect, as we replace it with our own
	q.onUpdate = @() function( _properties ) {}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		local actor = this.getContainer().getActor();
		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (this.isSkillValid(skill))
			{
				skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + this.m.ActionPointModifier);
			}
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return true;
	}
});
