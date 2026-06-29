::Hardened.HooksMod.hook("scripts/mods/mod_reforged/perk_group_collections/pgc_rf_exclusive_1", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Groups.push("pg.hd_swordmaster");
	}
});
