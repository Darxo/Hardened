::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_realized_potential", function(q) {
	// Overwrite, because we grant a different bonus
	q.onAdded = @() function()
	{
		if (this.m.IsNew)
		{
			local actor = this.getContainer().getActor();

			// Perk Reset
			actor.resetPerks();

			// Level Up
			actor.m.LevelUps++;

			// Shared Perk Group
			local preservedSeed = ::Math.rand(1, 99999999999);
			::Reforged.Math.seedRandom(actor.getUID(), this.getID());
			local perkTree = actor.getPerkTree();
			local newPerkGroupID = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_shared_1").getWeightedRandomPerkGroup(perkTree);
			if (newPerkGroupID != "DynamicPerks_NoPerkGroup")
			{
				perkTree.addPerkGroup(newPerkGroupID);
			}
			::Math.seedRandom(preservedSeed);
		}
	}
});
