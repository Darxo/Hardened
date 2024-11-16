::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bolster", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RequiredWeaponType = ::Const.Items.WeaponType.Polearm;
		this.m.RequiredWeaponReach = 0;
	}

// New Getter
	// If we are evaluating _target, potentially targeting them with _usedSkill, how would that change the targets perceived value?
	q.getQueryTargetMultAsUser = @(__original) function( _target, _usedSkill = null )	// Const
	{
		local ret = __original(_target, _usedSkill);
		if (_usedSkill == null) return ret;

		if (this.isSkillValid(_usedSkill))
		{
			local actor = this.getContainer().getActor();
			foreach (ally in ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1, true))
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
