::Hardened.HooksMod.hook("scripts/entity/world/entity_manager", function(q) {
	// Public
	q.m.HD_MercenariesBaseResources <- 180;		// Vanilla: 150

	// Private
	q.m.HD_BountyHunterManager <- null;		// weakrefs on all bounty hunter parties existing in the world

	q.create = @(__original) function()
	{
		__original();
		this.m.HD_BountyHunterManager = ::new("scripts/mods/mod_hardened/ai/world/bounty_hunter_manager");
	}

	q.update = @(__original) function()
	{
		__original();
		this.m.HD_BountyHunterManager.update();
	}

	// This is called like 30 times per second while unpaused for garbage collection purposes.
	// The actual meat of this function however is only executed once ever 3 seconds
	q.manageAIMercenaries = @(__original) function()
	{
		local oldMercenaryCompanyNames = ::Const.Strings.MercenaryCompanyNames;
		// We mock ::Math.min in order to target a specific day-scaling done by vanilla and disable it
		//	because spawn scaling is now done by ::Hardened.Global.getWorldDifficultyMult() globally
		local baseResources = this.m.HD_MercenariesBaseResources;
		local mockObject = ::Hardened.mockFunction(::Math, "min", function( _a, _b ) {
			if (_a == 330 && _b == 150 + ::World.getTime().Days)
			{
				// For performance reasons, we only actually switcheroo the names in here
				::Const.Strings.MercenaryCompanyNames = [::Hardened.util.findUnusedMercenaryName()];
				// We now have mercenaries start with 180 Base Resources (up from 150) at day 1, so that they scale a bit faster
				// This doesnt make them harder in the early game because their party has a HardMin of 6 anyways
				local newResources = baseResources * ::Hardened.Global.getWorldDifficultyMult() * ::Hardened.Global.FactionDifficulty.Mercenaries;
				return { done = true, value = newResources };
			}
		});

		__original();

		mockObject.cleanup();
		::Const.Strings.MercenaryCompanyNames = oldMercenaryCompanyNames;
	}

	q.clear = @(__original) function()
	{
		__original();
		this.m.HD_BountyHunterManager.clear();
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		this.m.HD_BountyHunterManager.onDeserialize();
	}
});
