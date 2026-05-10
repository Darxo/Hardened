::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_sleep", function(q) {
	// Overwrite, because there is no way to otherwise the usage of queryTargetValue
	q.findBestTarget = @(__original) function( _entity, _targets )	// Function is a generator.
	{
		local mockObject;
		mockObject = ::Hardened.mockFunction(this, "queryTargetValue", function( _user, _target, _skill = null ) {
			// Vanilla Fix: Call queryTargetValue with the actual skill instead of null
			if (_skill == null)
			{
				return { value = mockObject.original(_user, _target, this.m.Skill) };
			}
		});

		local generator = __original(_entity, _targets);	// Get the original generator
		local ret = resume generator;	// Variable to hold the value yielded by the generator

		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}

		mockObject.cleanup();			// The getFaction check happens during the first loop

		return ret;
	}
});
