::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/topbar/tactical_screen_topbar_event_log", function(q) {
	// Private
	q.m.LastSkillCounter <- null;	// Keep track of the last main-skill that produced logs

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

		// We save that root-skill counter, so that next time we know if we need to combine lines
		this.m.LastSkillCounter = ::Hardened.Temp.RootSkillCounter;
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
