::Hardened.HooksMod.hook("scripts/ai/world/orders/mercenary_order", function(q) {
	q.onExecute = @(__original) function(_entity, _hasChanged)
	{
		// We mock ::Math.min in order to target a specific day-scaling done by vanilla and disable it
		//	because spawn scaling is now done by ::Hardened.Global.getWorldDifficultyMult() globally
		local mockObject = ::Hardened.mockFunction(::Math, "min", function( _a, _b ) {
			if (_a == 350 && _b == 150 + ::World.getTime().Days)
			{
				local newResources = 150 * ::Hardened.Global.getWorldDifficultyMult() * ::Hardened.Global.FactionDifficulty.Mercenaries;
				return { done = true, value = newResources };
			}
		});

		local ret = __original(_entity, _hasChanged);

		mockObject.cleanup();

		return ret;
	}
});
