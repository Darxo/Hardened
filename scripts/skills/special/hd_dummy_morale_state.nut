// This base class is meant to generate accurate morale state tooltips for use as nested tooltips
this.hd_dummy_morale_state <- ::inherit("scripts/skills/special/morale_check", {
	m = {
		TargetMoraleState = ::Const.MoraleState.Confident
	},

	function create()
	{
		this.morale_check.create();
		this.m.ID = "special.HD_dummy_morale";
		this.m.Name = ::Const.MoraleStateName[this.m.TargetMoraleState];
	}

	function getTooltip()
	{
		local actor = this.getContainer().getActor();
		local oldMoraleState = actor.getMoraleState();
		actor.setMoraleState(this.m.TargetMoraleState);

		local ret = this.morale_check.getTooltip();

		foreach (entry in ret)
		{
			if (entry.id == 2 && entry.type == "description")
			{
				entry.text += "\n" + this.getName() + " is one of five " + ::Reforged.Mod.Tooltips.parseString(" [Morale States|Concept.Morale]");
			}
		}

		actor.setMoraleState(oldMoraleState);

		return ret;
	}
});
