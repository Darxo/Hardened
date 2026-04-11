::Hardened.HooksMod.hookTree("scripts/factions/faction_action", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Feat: We change the ScoreOverwrite of all contract related actions to 12, to allow for better scoring between them
		if (this.m.HD_ScoreOverwrite == null && ::IO.scriptFilenameByHash(this.ClassNameHash).find("factions/contracts") != null)
		{
			this.m.HD_ScoreOverwrite = 12;	// Vanilla: 1
		}
	}
});
