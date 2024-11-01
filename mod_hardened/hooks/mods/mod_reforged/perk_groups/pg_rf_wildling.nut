::Hardened.HooksMod.hook("scripts/mods/mod_reforged/perk_groups/pg_rf_wildling", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.PerkTreeMultipliers["pg.rf_ranged"] = 0.5;	// // In Reforged this is 0
		this.m.PerkTreeMultipliers["pg.special.rf_gifted"] = 1.0;	// // In Reforged this is 0
		this.m.PerkTreeMultipliers["pg.special.rf_leadership"] = 0.5;	// // In Reforged this is 0
	}
});
