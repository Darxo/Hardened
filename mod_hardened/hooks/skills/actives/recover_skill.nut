::Hardened.HooksMod.hook("scripts/skills/actives/recover_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.BeforeLast;	// We want this skill to be sorted very late in the skill bar as it is rarely used and shouldnt replace important hotkeys
	}}.create;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain the [Waiting|Skill+hd_wait_effect] effect"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Never costs more than your maximum [Action Points|Concept.ActionPoints]"),
		});

		return ret;
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// Feat: We make recover never cost more action points than the maximum action points available
		this.m.ActionPointCost = ::Math.min(this.m.ActionPointCost, _properties.ActionPoints);
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);
		if (ret)
		{
			this.getContainer().add(::new("scripts/skills/effects/hd_wait_effect"));	// This will remove itself if it detects the presence of Relentless
		}
		return ret;
	}
});
