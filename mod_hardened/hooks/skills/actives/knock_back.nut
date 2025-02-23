::Hardened.HooksMod.hook("scripts/skills/actives/knock_back", function(q) {
	q.onUse = @(__original) function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local wasTargetHit = true;

		local mockObjectOnMissed = ::Hardened.mockFunction(target, "onMissed", function( _attacker, _skill ) {
			if (::Hardened.getFunctionCaller(1) == "onUse")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
			{
				wasTargetHit = false;
			}
		});

		__original(_user, _targetTile);

		mockObjectOnMissed.cleanup();

		// Vanilla Fix: Vanilla never calls the events for hitting or missing with knock back, so certain skills interact with it incorrectly (e.g. Fast Adaptation in Vanilla)
		if (wasTargetHit)
		{
			this.getContainer().getActor().getSkills().onTargetHit(this, target, ::Const.BodyPart.Body, 0, 0);
		}
		else
		{
			this.getContainer().getActor().getSkills().onTargetMissed(this, target);
		}
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		return ret && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab;
	}
});
