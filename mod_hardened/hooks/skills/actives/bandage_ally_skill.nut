::Hardened.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
	// Within this amount of rounds from receiving an injury, it can be treated with a bandage
	// 0 means, that an injury is only treatable during the same round
	q.m.TreatableRoundWindow <- 1;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 7 && ::String.contains(entry.text, "Cut Artery"))
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Treats any injury that was received at most " + ::MSU.Text.colorPositive(this.m.TreatableRoundWindow) + " [Round(s)|Concept.Round] ago");
			}
		}

		return ret;
	}

	// We replace the vanilla function because cut artery, cut throat and grazed neck now behave like the other injuries
	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (!this.getContainer().getActor().isAlliedWith(target)) return false;
		if (_targetTile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())) return false;

		foreach (skill in target.getSkills().m.Skills)
		{
			if (skill.getID() == "effects.bleeding")
			{
				return true;
			}
			if (skill.isType(::Const.SkillType.TemporaryInjury) && skill.isFresh() && !skill.isTreated())
			{
				local roundsSinceAdded = ::Tactical.TurnSequenceBar.getCurrentRound() - skill.m.RoundAdded;
				if (roundsSinceAdded <= this.m.TreatableRoundWindow)
				{
					return true;
				}
			}
		}
	}

	// We replace the vanilla function because cut artery, cut throat and grazed neck are no longer removed
	q.onUse = @() function( _user, _targetTile )
	{
		this.spawnIcon("perk_55", _targetTile);

		local target = _targetTile.getEntity();
		foreach (skill in target.getSkills().m.Skills)
		{
			if (skill.getID() == "effects.bleeding")	// We could also use removeAllByID for the bleed effects, but this is a bit more performant
			{
				skill.removeSelf();
			}
			else if (skill.isType(::Const.SkillType.TemporaryInjury) && skill.isFresh() && !skill.isTreated())
			{
				local roundsSinceAdded = ::Tactical.TurnSequenceBar.getCurrentRound() - skill.m.RoundAdded;
				if (roundsSinceAdded <= this.m.TreatableRoundWindow)
				{
					skill.setTreated(true);
					::World.Statistics.getFlags().increment("InjuriesTreatedWithBandage");
				}
			}
		}

		// Unlike Vanilla (which calls removeById) we only set IsGarbage of the targeted bleed skills to true. The target still needs to be force-updated by someone so the changes take effect
		target.getSkills().update();

		if (!::MSU.isNull(this.getItem()))
		{
			this.getItem().removeSelf();
		}

		this.updateAchievement("FirstAid", 1, 1);
		return true;
	}
});
