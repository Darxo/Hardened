::Hardened.HooksMod.hook("scripts/skills/special/mood_check", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 2 && entry.type == "description")
			{
				entry.text += ::Reforged.Mod.Tooltips.parseString("\n\nSee also: [Mood|Concept.Mood]");
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// We show the accurate mood, instead of a percentage representation of it
		local actor = this.getContainer().getActor();
		this.m.Name = ::Const.MoodStateName[actor.getMoodState()] + " (" + actor.getMood() + "/7.0)";
	}
});
