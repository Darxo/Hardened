::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/topbar/tactical_screen_topbar_event_log", function(q) {
	// Private
	q.m.LastSkillCounter <- null;	// Keep track of the last main-skill that produced logs

	q.log = @(__original) function( _text )
	{
		if (!::Hardened.Mod.ModSettings.getSetting("CombineCombatSkillLogs").getValue() || ::Hardened.Temp.RootSkillCounter == null)
		{
			return __original(_text);
		}

		if (::Hardened.Temp.RootSkillCounter == this.m.LastSkillCounter)
		{
			// If we meet the new root-skill counter the second time around and any future times, we redirect logs so they don't produce newlines
			this.logEx(_text);
		}
		else
		{
			// If the current root-skill is different from the last one we generated logs for, we don't change the behavior and let it create a newline
			// We save that root-skill counter
			this.m.LastSkillCounter = ::Hardened.Temp.RootSkillCounter;
			__original(_text);
		}
	}
});
