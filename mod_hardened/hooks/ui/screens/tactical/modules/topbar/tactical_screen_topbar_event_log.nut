::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/topbar/tactical_screen_topbar_event_log", function(q) {
	// Private
	q.m.LastSkillCounter <- null;	// Keep track of the last main-skill that produced logs

	// Can be set from the outside to tran
	// If true, then any call to logEx will be transformed to log
	// Can be set to true from the outside, e.g. when a turn starts/ends or a skill executed fully
	// Will be set to false whenever `log` is called or whenever a `logEx` has been transformed to `log`
	q.m.HD_IsForcingNewLine <- false;

	q.log_newline = @(__original) function()
	{
		this.m.HD_IsForcingNewLine = false;

		// Our feature to combine logs explicitely wants no newlines in betwee, so we interrupt all of these calls
		if (!this.HD_isCombiningLogs())
		{
			__original();
		}
	}

	q.log = @(__original) function( _text )
	{
		if (this.HD_isCombiningLogs())
		{
			// Feat: We combine log lines under certain circumstances to make the log more readable
			this.logEx(_text);
		}
		else
		{
			__original(_text);
		}

		this.m.HD_IsForcingNewLine = false;

		// We save that root-skill counter, so that next time we know if we need to combine lines
		this.m.LastSkillCounter = ::Hardened.Temp.RootSkillCounter;
	}

	q.logEx = @(__original) function( _text )
	{
		if (this.m.HD_IsForcingNewLine)
		{
			this.m.HD_IsForcingNewLine = false;
			return this.log(_text);
		}

		__original(_text);
	}

// New Functions
	q.HD_isCombiningLogs <- function()
	{
		if (::Hardened.Temp.RootSkillCounter == null) return false;		// We are not in the execution of a skill
		if (::Hardened.Temp.RootSkillCounter != this.m.LastSkillCounter) return false;
		if (!::Hardened.Mod.ModSettings.getSetting("CombineCombatSkillLogs").getValue()) return false;		// Mod setting is not active

		return true;
	}
});
