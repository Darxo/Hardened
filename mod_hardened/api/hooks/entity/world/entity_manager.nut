::Hardened.HooksMod.hook("scripts/entity/world/entity_manager", function(q) {
	q.manageAIMercenaries = @(__original) function()
	{
		// We mock ::Math.min in order to target a specific day-scaling done by vanilla and disable it
		//	because spawn scaling is now done by ::Hardened.Global.getWorldDifficultyMult() globally
		local mockObject = ::Hardened.mockFunction(::Math, "min", function( _a, _b ) {
			if (_a == 330 && _b == 150 + ::World.getTime().Days)
			{
				return { done = true, value = 150 };
			}
		});

		__original();

		mockObject.cleanup();
	}
});
