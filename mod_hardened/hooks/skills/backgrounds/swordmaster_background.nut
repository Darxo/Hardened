::Hardened.HooksMod.hook("scripts/skills/backgrounds/swordmaster_background", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Just like Vanilla we now allow swordmasters to have talents in ranged defense again
		::MSU.Array.removeByValue(this.m.ExcludedTalents, ::Const.Attributes.RangedDefense)

		this.m.HiringCost = 1400; 	// Vanilla: 400; Reforged: 2400
		this.m.DailyCost = 45; 		// Vanilla: 35; Reforged: 45
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10)
			{
				ret.remove(index);	// Remove entry about sword mastery perk
				break;
			}
		}

		return ret;
	}

	q.createPerkTreeBlueprint = @(__original) { function createPerkTreeBlueprint()
	{
		// We are not changing the swordmaster perks for the swordmaster origin
		if (::World.Assets.getOrigin().getID() == "scenario.rf_old_swordmaster")
		{
			return __original();
		}

		return ::new(::DynamicPerks.Class.PerkTree).init({
			DynamicMap = {
				"pgc.rf_exclusive_1": [
					"pg.hd_swordmaster",
				],
				"pgc.rf_shared_1": [],
				"pgc.rf_weapon": [],
				"pgc.rf_armor": [
					"pg.rf_light_armor",
					"pg.rf_medium_armor",
				],
				"pgc.rf_fighting_style": [
					"pg.rf_power",
					"pg.rf_shield",
					"pg.rf_swift",
				]
			}
		});
	}}.createPerkTreeBlueprint;

	q.getPerkGroupCollectionMin = @(__original) { function getPerkGroupCollectionMin( _collection )
	{
		// We remove the restriction of this background to only have one weapon perk group
		if (_collection.getID() == "pgc.rf_weapon")
		{
			return _collection.getMin();
		}

		return __original(_collection);
	}}.getPerkGroupCollectionMin;

	q.onAdded = @(__original) function()
	{
		local isNew = this.m.IsNew;	// This member is set to false during __original;

		__original();

		if (isNew)
		{
			this.getContainer().removeByID("perk.mastery.sword");	// Swordmaster no longer have this perk unlocked by default
		}
	}
});
