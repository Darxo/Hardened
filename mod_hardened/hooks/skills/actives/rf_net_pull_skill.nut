::Hardened.HooksMod.hook("scripts/skills/actives/rf_net_pull_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "skills/hd_net_pull_skill.png";	// This modified icon has more contrast and is brighter
		this.m.IsAttack = false;	// In Reforged this is true
		this.m.FatigueCost = 30;	// In Reforges this is 25
		this.m.MaxRange = 3;	// In Reforged this is 2
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		// This skill is no longer an attack, so we need to manually make sure you can't use it on allies
		if (ret && this.getContainer().getActor().isAlliedWith(_targetTile.getEntity())) ret = false;

		return ret;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (::MSU.isNull(_skill)) return ret;
		if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

		if (_user.getID() == this.getContainer().getActor().getID())	// We are the _user
		{
			// A character with Net Pull is designed around being able to deal with an enemy being pulled adjacent to them
			// Net Pull also has to compete with the normal Throw Net ability, which is cheaper and more versatile
			// Therefor, we massively boost the value when targeting something with Net Pull, so it will against win Throw Net
			if (_skill.getID() == this.getID())
			{
				ret *= 5.0;
			}
		}

		return ret;
	}
});
