::Hardened.HooksMod.hook("scripts/skills/actives/disarm_skill", function(q) {
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		return ret && !_targetTile.getEntity().getCurrentProperties().IsImmuneToDisarm;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_skill == null || this.getID() != _skill.getID()) return ret;	// We only care about situations, where this skill is used

		if (_user.getID() == this.getContainer().getActor().getID() && _user.getID() != _target.getID())	// We must be the _user
		{
			if (_target.getSkills().hasSkill("actives.spearwall") || _target.getSkills().hasSkill("actives.riposte"))
			{
				ret *= 1.5;	// Disarm will cancel spearwall and riposte so we are encouraged to disarm such a character
			}
		}

		return ret;
	}
});
