::Hardened.HooksMod.hook("scripts/entity/world/entity_manager", function(q) {
	q.manageAIMercenaries = @(__original) function()
	{
		// We mock ::Math.min in order to target a specific day-scaling done by vanilla and disable it
		//	because spawn scaling is now done by ::Hardened.Global.getWorldDifficultyMult() globally
		local mockObject = ::Hardened.mockFunction(::Math, "min", function( _a, _b ) {
			if (_a == 330 && _b == 150 + ::World.getTime().Days)
			{
				// We now have mercenaries start with 180 Base Resources (up from 150) at day 1, so that they scale a bit faster
				// This doesnt make them harder in the early game because their party has a HardMin of 6 anyways
				local newResources = 180 * ::Hardened.Global.getWorldDifficultyMult() * ::Hardened.Global.FactionDifficulty.Mercenaries;
				return { done = true, value = newResources };
			}
		});

		__original();

		mockObject.cleanup();
	}
});
