::Hardened.HooksMod.hook("scripts/skills/backgrounds/slave_barbarian_background", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.PerkTree = ::new(::DynamicPerks.Class.PerkTree).init({
			DynamicMap = {
				"pgc.rf_exclusive_1": @(_perkTree) [
					::MSU.Class.WeightedContainer([
						[20, "pg.rf_knave"],
						[20, "pg.rf_laborer"],
						[20, "pg.rf_raider"],
						[10, "pg.rf_militia"],
						[10, "pg.rf_trapper"],
						[10, "pg.rf_soldier"],
						[5, "pg.rf_noble"],
						[5, "pg.rf_wildling"],
					]).roll()
				],
				"pgc.rf_shared_1": [],
				"pgc.rf_weapon": [],
				"pgc.rf_armor": [],
				"pgc.rf_fighting_style": []
			}
		});
	}
});
