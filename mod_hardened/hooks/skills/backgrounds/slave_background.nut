::Hardened.HooksMod.hook("scripts/skills/backgrounds/slave_background", function(q) {
	// Overwrite, because we adjust, how the exclusive perk group is rolled
	q.createPerkTreeBlueprint = @() function()
	{
		return ::new(::DynamicPerks.Class.PerkTree).init({
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
					]).roll(),
				],
				"pgc.rf_shared_1": [],
				"pgc.rf_weapon": [],
				"pgc.rf_armor": [],
				"pgc.rf_fighting_style": [],
			}
		});
	}

	// Overwrite, because we delete the Reforged adjustments and revert back to Vanilla
	q.onChangeAttributes = @() function()
	{
		return {
			Hitpoints = [-10, -10],
			Bravery = [-5, 0],
			Stamina = [0, 0],
			MeleeSkill = [0, 0],
			RangedSkill = [0, 0],
			MeleeDefense = [0, 0],
			RangedDefense = [0, 0],
			Initiative = [-5, -5],
		};
	}
});
