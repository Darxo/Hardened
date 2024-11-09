::Hardened.HooksMod.hook("scripts/mods/mod_reforged/perk_groups/pg_rf_knave", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.PerkTreeMultipliers["pg.rf_dagger"] = 2.0;	// // In Reforged this is -1
		this.m.PerkTreeMultipliers["pg.rf_light_armor"] = 1.0;	// // In Reforged this is -1
	}
});
