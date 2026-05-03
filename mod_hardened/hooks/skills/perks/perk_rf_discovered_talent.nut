::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_discovered_talent", function(q) {
	// Public
	// We completely disable the Reforged Star Gain per Level-Up, by setting the following value to 0
	q.m.MaxStars = 0;	// Reforged: 3

	q.onAdded = @() function()
	{
		if (this.m.IsNew)
		{
			local preservedSeed = ::Math.rand();
			::Reforged.Math.seedRandom(this.getContainer().getActor().getUID(), this.getID(), "HD_FixedDiscoveredTalentSeed");
			this.HD_addTripleStar();
			this.HD_addFightingStyle();
			::Math.seedRandom(preservedSeed);
		}
	}

// New Functions
	q.HD_addTripleStar <- function()
	{
		local actor = this.getContainer().getActor();
		local potentialAttributes = [];
		foreach (attribute in ::Const.Attributes)
		{
			if (attribute == ::Const.Attributes.COUNT) continue;
			if (actor.getTalents()[attribute] > 0) continue;
			potentialAttributes.push(attribute);
		}

		actor.getTalents()[::MSU.Array.rand(potentialAttributes)] = 3;

		// Recalculate all attribute rolls
		actor.m.Attributes.clear();
		actor.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - actor.getLevel() + actor.m.LevelUps);
	}

	q.HD_addFightingStyle <- function()
	{
		local perkTree = this.getContainer().getActor().getPerkTree();
		local fightingStylePgc = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_fighting_style");
		local excludePerkGroups = [];
		foreach (perkGroupCollectionID in fightingStylePgc.getGroups())
		{
			if (perkTree.hasPerkGroup(perkGroupCollectionID)) excludePerkGroups.push(perkGroupCollectionID);
		}

		local newPerkGroupID = fightingStylePgc.getRandomGroup(excludePerkGroups);
		if (newPerkGroupID != "DynamicPerks_NoPerkGroup")
		{
			perkTree.addPerkGroup(newPerkGroupID);
		}
	}
});
