::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_swallow_whole", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		// We allow nachzehrer to consider swalling even if that is the last enemy they know of by tricking vanilla in always thinking there are 2 known enemies in this situation
		local mockObject = ::Hardened.mockFunction(this.getAgent(), "getKnownOpponents", function() {
			if (::Hardened.getFunctionCaller(1) == "onEvaluate")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
			{
				local dummyPlayer = ::MSU.getDummyPlayer();	// The dummy player is by default from the player faction, so it is ideal for our use here

				// The important thing here is that the returned array has 2 tables with an Array which is a weakref to a player controlled character
				return { done = false, value = [{Actor = ::MSU.asWeakTableRef(dummyPlayer)}, {Actor = ::MSU.asWeakTableRef(dummyPlayer)}] };
			}
		});

		local ret = __original(_entity);
		mockObject.cleanup();	// It is very likely that our mock function was never called, so we must clean up now
		return ret;
	}
});
