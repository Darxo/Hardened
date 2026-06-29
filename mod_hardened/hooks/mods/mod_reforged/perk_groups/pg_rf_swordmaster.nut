::Hardened.HooksMod.hook("scripts/mods/mod_reforged/perk_groups/pg_rf_swordmaster", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Name = "Old " + this.m.Name;
	}
});
