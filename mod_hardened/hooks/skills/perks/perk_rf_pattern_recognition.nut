::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_pattern_recognition", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";	// For clarity during battles this perk no longer displays a mini icon
	}

// Reforged Functions
	// Overwrite, because we change the effect of this perk. It now provides 2 Stats for each registered attack at all times, instead of 3 and then 1
	q.getBonus = @() function( _opponentID )
	{
		return this.m.Opponents[_opponentID] * 2;
	}
});
