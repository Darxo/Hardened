::Hardened.HooksMod.hook("scripts/skills/actives/knock_back", function(q) {
	// We hook onUse to display the exact hitchances of knock_back in the log and even produce a log on a miss
	q.onUse = @(__original) function( _user, _targetTile )
	{
		local hitroll = null;	// We hook the ::Math.rand function to fetch the result of every every random 1-100 roll happening into this variable
		local hitchance = null;	// We hook the getHitchance function to fetch its result into this variable

		local mockObjectRand;
		mockObjectRand = ::Hardened.mockFunction(::Math, "rand", function(...) {
			if (hitchance == null && vargv.len() == 2 && vargv[0] == 1 && vargv[1] == 100)
			{
				local ret = mockObjectRand.original(vargv[0], vargv[1]);
				hitroll = ret;
				return { value = ret };
			}
		});

		local mockObjectGetHitchance;
		mockObjectGetHitchance = ::Hardened.mockFunction(this, "getHitchance", function( _targetEntity ) {
			if (hitroll != null && hitchance == null)
			{
				local ret = mockObjectGetHitchance.original(_targetEntity);
				hitchance = ret;
				return { value = ret };
			}
		});

		local mockObjectLog = ::Hardened.mockFunction(::Tactical.EventLog, "log", function( _text ) {
			if (_text.find(" has knocked back ") != null)	// We stop vanilla from printing combat logs, containing this phrase
			{
				return { value = null };
			}
		});

		__original(_user, _targetTile);
		local wasTargetHit = (hitroll <= hitchance);

		mockObjectRand.cleanup();
		mockObjectGetHitchance.cleanup();
		mockObjectLog.cleanup();

		// Now we produce a standardized tooltip for whether this skill has hit or missed the target, including the roll and hitchance
		local target = _targetTile.getEntity();
		if (wasTargetHit)
		{
			if (hitchance != null) ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + ::Const.UI.getColorizedEntityName(target) + " (Chance: " + hitchance + ", Rolled: " + hitroll + ")");
		}
		else
		{
			if (hitchance != null) ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and misses " + ::Const.UI.getColorizedEntityName(target) + " (Chance: " + hitchance + ", Rolled: " + hitroll + ")");
		}
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		return ret && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab && (this.findTileToKnockBackTo(_originTile, _targetTile) != null);
	}
});
