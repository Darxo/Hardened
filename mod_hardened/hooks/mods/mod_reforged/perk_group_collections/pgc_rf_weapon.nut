::Hardened.HooksMod.hook("scripts/mods/mod_reforged/perk_group_collections/pgc_rf_weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Min = 4;		// Reforged: 3
	}
});
