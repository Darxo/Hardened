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

	q.onSerialize = @(__original) function( _out )
	{
		::Hardened.FlaggedPerks.onSerialize(this);
		__original(_out);
		::Hardened.FlaggedPerks.onDeserialize(this);	// Now we have to return the perks to the player, as he will want to continue playing
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::Hardened.FlaggedPerks.onDeserialize(this);
	}
});
