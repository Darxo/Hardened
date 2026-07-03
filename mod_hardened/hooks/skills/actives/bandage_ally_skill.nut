::Hardened.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
	// Within this amount of rounds from receiving an injury, it can be treated with a bandage
	// 0 means, that an injury is only treatable during the same round
	q.m.TreatableRoundWindow <- 1;

// Hardened
	q.m.HD_UsableWhileEngagedInMelee = false;

	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "Save yourself or another character by applying pressure and provisional bandaging to any fresh wound.";
	}

	q.onAdded = @(__original) function()
	{
		__original();

		local actor = this.getContainer().getActor();
		if (actor.isPlayerControlled()) return;
		if (actor.getAIAgent().findBehavior(::Const.AI.Behavior.ID.HD_Bandage_Ally) == null)
		{
			actor.getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/hd_ai_bandage_ally"));
			actor.getAIAgent().finalizeBehaviors();
		}
	}

	q.getTooltip = @() function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Target yourself or an ally who is not [Engaged in Melee|Concept.ZoneOfControl]. Remove [Bleeding|Skill+bleeding_effect] from that target and treat any [Injuries|Concept.InjuryTemporary] that were received [recently|Concept.Recently]"),
		});

		return ret;
	}

	// We replace the vanilla function because cut artery, cut throat and grazed neck now behave like the other injuries
	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;

		local target = _targetTile.getEntity();
		if (!this.getContainer().getActor().isAlliedWith(target)) return false;
		if (target.HD_isEngagedInMelee()) return false;
		if (!this.HD_hasTreatableEffects(target)) return false;

		return true;
	}

	q.isUsable = @() function()
	{
		return this.skill.isUsable();
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

// New Functions
	q.HD_hasTreatableEffects <- function( _target )
	{
		foreach (skill in _target.getSkills().m.Skills)
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

		return false;
	}
});
