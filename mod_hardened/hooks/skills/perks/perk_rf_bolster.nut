::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bolster", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RequiredWeaponType = ::Const.Items.WeaponType.Polearm;
		this.m.RequiredWeaponReach = 0;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;		// We must be the _user

		if (_skill != null && this.isSkillValid(_skill))
		{
			foreach (ally in ::Tactical.Entities.getFactionActors(_user.getFaction(), _user.getTile(), 1, true))
			{
				if (ally.getMoraleState() < ally.m.MaxMoraleState)
				{
					ret *= 1.1;		// Every ally, whose morale I could raise with the bolster morale check increases the value of the target
				}
			}
		}

		return ret;
	}
});
