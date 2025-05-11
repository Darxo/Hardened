// This hook also removes the natural hitchance bonus from hook but that is exactly what we want
::Hardened.removeTooClosePenalty("scripts/skills/actives/hook");

::Hardened.HooksMod.hook("scripts/skills/actives/hook", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png" && ::String.contains(entry.text, "+10%"))
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	// We hook onUse to display the exact hitchances of hook in the log and even produce a log on a miss
	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (_user.isHiddenToPlayer() || !_targetTile.IsVisibleForPlayer)
			return __original(_user, _targetTile);

		local hitroll = null;	// We hook the ::Math.rand function to fetch the result of every every random 1-100 roll happening into this variable

		local mockObjectRand;
		mockObjectRand = ::Hardened.mockFunction(::Math, "rand", function(...) {
			if (vargv.len() == 2 && vargv[0] == 1 && vargv[1] == 100)
			{
				local ret = mockObjectRand.original(vargv[0], vargv[1]);
				hitroll = ret;
				return { value = ret };
			}
		});

		local mockObjectGetHitchance;
		mockObjectGetHitchance = ::Hardened.mockFunction(this, "getHitchance", function( _targetEntity ) {
			if (hitroll != null)
			{
				local hitchance = mockObjectGetHitchance.original(_targetEntity);

				// Now we produce a standardized tooltip for whether this skill has hit or missed the target, including the roll and hitchance
				::Tactical.EventLog.log(format(
					"%s uses %s and %s %s (Chance: %i, Rolled: %i)",
					::Const.UI.getColorizedEntityName(_user),
					this.getName(),
					(hitroll <= hitchance) ? "hits" : "misses",
					::Const.UI.getColorizedEntityName(_targetEntity),
					hitchance,
					hitroll
				));

				return { done = true, value = hitchance };
			}
		});

		__original(_user, _targetTile);

		mockObjectRand.cleanup();
		mockObjectGetHitchance.cleanup();
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		return ret && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab && (this.getPulledToTile(_originTile, _targetTile) != null);
	}
});
