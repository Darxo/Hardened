::Hardened.HooksMod.hook("scripts/mods/mod_reforged/perk_group_collections/pgc_rf_weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// Revert the removal of Polearm Group from the Weapon Groups
		foreach (index, id in this.m.Groups)
		{
			if (id == "pg.rf_spear")	// Insert polearm mastery right after spear mastery, where it used to be
			{
				this.m.Groups.insert(index, "pg.rf_polearm");
				break;
			}
		}
	}
});
