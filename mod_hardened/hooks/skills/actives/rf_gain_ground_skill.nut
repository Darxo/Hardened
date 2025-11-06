::Hardened.HooksMod.hook("scripts/skills/actives/rf_gain_ground_skill", function(q) {
	// Private
	q.m.IsEffectActive <- false,	// This skill will apply a debuff for the rest of this turn, controlled by this flag

	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 0;
	}

	// Overwrite, because we improve the tooltip
	q.getTooltip = @() function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Move to an tile of an adjacent enemy you just killed, ignoring [Zone of Control|Concept.ZoneOfControl] and [Spearwall|Skill+spearwall_effect]"),
		});

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used while [rooted|Concept.Rooted]"),
			});
		}

		if (this.m.ValidTiles.len() == 0)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Can only be used immediately after killing an adjacent target"),
			});
		}

		return ret;
	}

	// Overwrite, because we change the cost to 0 and 0 all the time and not make it dependant on the current tile
	q.getCostString = @() function()
	{
		return this.skill.getCostString();
	}

	// Overwrite, because we keep the cost to 0 and 0 all the time and not make it dependant on the current tile
	q.onAfterUpdate = @() function( _properties ) { }
});
