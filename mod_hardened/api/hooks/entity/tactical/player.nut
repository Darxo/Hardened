::Hardened.HooksMod.hook("scripts/entity/tactical/player", function(q) {
// New Functions
	q.getXPMult <- function()
	{
		local oldCombatStatsXP = this.m.CombatStats.XPGained;
		local oldXP = this.m.XP;
		this.addXP(10000);

		local xpDifference = this.m.XP - oldXP;

		this.m.CombatStats.XPGained = oldCombatStatsXP;
		this.m.XP = oldXP;

		return xpDifference / 10000.0;
	}
});
