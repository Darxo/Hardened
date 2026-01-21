::Hardened.HooksMod.hook("scripts/skills/special/mood_check", function(q) {
	q.m.HD_MoodModifierArray <- [
		0.0, 		// Angry
		0.0, 		// Disgruntled
		0.0,		// Concerned
		0.0,		// Neutral
		0.0,		// InGoodSpirit
		-0.2,		// Eager
		-0.3,		// Euphoric
	];

	// Overwrite, because we implement the varying name including the current value of this effect the moment that value is fetched
	// Vanilla instead manipulates this.m.Name during onUpdate, but that will only update when the brother updates (not when changing settings)
	q.getName = @() function()
	{
		local actor = this.getContainer().getActor();
		local ret = ::Const.MoodStateName[actor.getMoodState()];

		if (::Hardened.Mod.ModSettings.getSetting("ShowAbsoluteMoodValue").getValue())
		{
			// We show the accurate mood, instead of a percentage representation of it
			ret += " (" + actor.getMood() + "/7.0)";
		}

		return ret;
	}

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

		local moodModifier = this.m.HD_MoodModifierArray[this.getContainer().getActor().getMoodState()];
		if (moodModifier != 0)
		{
			local textPosNeg = moodModifier > 0 ? "negative" : "positive";	// A negative percentage only affects positive changes and vise versa
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Receive " + ::MSU.Text.colorizeValue(moodModifier, {AddSign = true}) + " Mood from " + textPosNeg + " Mood Changes (to a minimum of " + ::MSU.Text.colorNeutral("0") + ")",
			});
		}

		return ret;
	}

// New Functions
	// Adjust a proposed mood change, depending on custom rules inside this skill
	// Return the new modified mood change
	q.HD_getNewMoodChange <- function( _currentMoodChange )
	{
		local moodModifier = this.m.HD_MoodModifierArray[this.getContainer().getActor().getMoodState()];

		// We decide that a modifier can only ever tweak _currentMoodChange to move closer to 0, never further away from it
		return ::Math.clampf(_currentMoodChange + moodModifier, 0.0, _currentMoodChange);
	}
});
