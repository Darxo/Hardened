::Hardened.HooksMod.hook("scripts/entity/tactical/player", function(q) {
	// Public
	q.m.HD_XPValueBase <- 70;				// Any Brother will count for this much xp by default
	q.m.HD_XPValuePerRegularLevel <- 30;	// A regular level (up until veteran level) will count for this much XP
	q.m.HD_XPValuePerVeteranLevel <- 30;	// A veteran level will count for this much XP

	// Overwrite, because we adjust the xp formular a bit, increasing the gain from levels to 50 (up from 30)
	q.getXPValue = @() function()
	{
		local regularLevelsGained = ::Math.min(this.m.Level, ::Const.XP.MaxLevelWithPerkpoints);
		local veteranLevelsGained = ::Math.max(this.m.Level - ::Const.XP.MaxLevelWithPerkpoints, 0);
		return this.m.HD_XPValueBase + regularLevelsGained * this.m.HD_XPValuePerRegularLevel + veteranLevelsGained * this.m.HD_XPValuePerVeteranLevel;
	}
});
