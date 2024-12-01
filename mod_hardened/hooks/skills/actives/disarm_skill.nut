::Hardened.HooksMod.hook("scripts/skills/actives/disarm_skill", function(q) {
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		return ret && !_targetTile.getEntity().getCurrentProperties().IsImmuneToDisarm;
	}

// Hardened Functions
	q.getQueryTargetMultAsUser = @(__original) function( _target, _usedSkill = null )
	{
		local ret = __original(_target, _usedSkill);
		if (_usedSkill == null) return ret;

		if (_usedSkill.getID() == this.getID())
		{
			if (_target.getSkills().hasSkill("actives.spearwall") || _target.getSkills().hasSkill("actives.riposte"))
			{
				ret *= 1.5;	// Disarm will cancel spearwall and riposte so we are encouraged to disarm such a character
			}
		}

		return ret;
	}
});
