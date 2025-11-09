::Hardened.HooksMod.hook("scripts/skills/actives/rf_onslaught_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "skills/hd_onslaught_skill.png";	// This modified icon has more contrast and is brighter
		this.m.SoundOnUse = ["sounds/enemy_sighted_02.wav"];
		this.m.MaxRange = 4;		// In Reforged this is unused (0)
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("You and your allies within " + ::MSU.Text.colorPositive(this.m.MaxRange) + " tiles gain the [Onslaught|Skill+rf_onslaught_effect] effect for two [rounds|Concept.Round]");
			}
			else if (entry.id == 21)
			{
				entry.text = "Can only be used once per battle";
			}
			else if (entry.id == 22)
			{
				entry.text = ::MSU.Text.colorNegative("Has already been used this battle");
			}
		}

		return ret;
	}

	// Overwrite because we change a few things:
	// 	- Remove one-per-company rule;
	// 	- Utilize MinRange/MaxRange member;
	// 	- Remove varying turn duration logic (instead they now always last 2 rounds on the target)
	q.onUse = @() function( _user, _targetTile )
	{
		this.m.IsSpent = true;

		local myTile = _user.getTile();
		foreach (ally in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()))
		{
			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
			if (ally.getCurrentProperties().IsStunned) continue;

			if (ally.getTile().getDistanceTo(myTile) >= this.getMinRange() && ally.getTile().getDistanceTo(myTile) <= this.getMaxRange())
			{
				ally.getSkills().add(::new("scripts/skills/effects/rf_onslaught_effect"));
			}
		}

		return true;
	}
});
