::Hardened.HooksMod.hook("scripts/skills/actives/throw_dirt_skill", function(q) {
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return __original(_originTile, _targetTile) && !_targetTile.getEntity().getSkills().hasSkill("effects.hd_headless");
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_user.getID() == this.getContainer().getActor().getID())	// We must be the _user
		{
			if (!_target.hasZoneOfControl()) return ret;	// We only care about cases where we can disable the zone of control of an enemy
			if (!_target.isTurnDone()) return ret;			// We dont care about enemies who still have a turn as distracted would run out before it can save an ally

			// We check whether there are adjacent fleeing allies next to our target
			local adjacentFactionAllies = ::Tactical.Entities.getAlliedActors(_user.getFaction(), _target.getTile(), 1, true);
			foreach (ally in adjacentFactionAllies)
			{
				if (ally.getMoraleState() == ::Const.MoraleState.Fleeing)
				{
					ret *= 2.0;
				}
			}
		}

		return ret;
	}
});
