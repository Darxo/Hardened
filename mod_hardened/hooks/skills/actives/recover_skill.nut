::Hardened.HooksMod.hook("scripts/skills/actives/recover_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.BeforeLast;	// We want this skill to be sorted very late in the skill bar as it is rarely used and shouldnt replace important hotkeys
	}}.create;

	// Overwrite, because we change too many tooltips
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::Reforged.Mod.Tooltips.parseString("Recover [Fatigue|Concept.Fatigue] equal to " + ::MSU.Text.colorPositive("50%") + " of your [Stamina|Concept.MaximumFatigue]"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [$ $|Skill+hd_wait_effect]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("End your [$ $|Concept.Turn]"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Never costs more than your maximum [Action Points|Concept.ActionPoints]"),
		});

		if (this.m.HasMovedOrUsedSkill)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because you moved or have used a skill this [$ $|Concept.Turn]"),
			});
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used if you moved or have used a skill this [$ $|Concept.Turn]"),
			});
		}

		return ret;
	}}.getTooltip;

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// Feat: We make recover never cost more action points than the maximum action points available
		this.m.ActionPointCost = ::Math.min(this.m.ActionPointCost, _properties.ActionPoints);
	}

	// Overwrite, because we no longer set the remaining action points to 0 and we produce a combat logs with the fatigue recovered
	q.onUse = @() { function onUse( _user, _targetTile )
	{
		_user.HD_recoverFatigue(this.getFatigueRecovered());
		_user.getSkills().add(::new("scripts/skills/effects/hd_wait_effect"));	// This will remove itself if it detects the presence of Relentless
		_user.m.IsTurnDone = true;

		if (!_user.isHiddenToPlayer())
		{
			_user.playSound(::Const.Sound.ActorEvent.Fatigue, ::Const.Sound.Volume.Actor * _user.getSoundVolume(::Const.Sound.ActorEvent.Fatigue));
		}

		return true;
	}}.onUse;

// Reforged Functions
	// Overwrite, because we change the effect to using Stamina as reference, rather than built-up Fatigue
	q.getFatigueRecovered = @() { function getFatigueRecovered()
	{
		return ::Math.ceil(this.getContainer().getActor().getStamina() * 0.5);;
	}}.getFatigueRecovered;
});
