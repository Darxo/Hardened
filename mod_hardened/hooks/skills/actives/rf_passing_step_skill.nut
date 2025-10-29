::Hardened.HooksMod.hook("scripts/skills/actives/rf_passing_step_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RequiredDamageType = null;	// Any damage type is allowed, as long as it came from a sword
		this.m.RequireOffhandFree = false;	// Anything in the offhand is allowed
	}

	q.getCostString = @(__original) function()
	{
		if (this.getContainer().getActor().isPlacedOnMap()) return __original();

		return "Cost is based on Starting Tile Type";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/special.png")
			{
				// We rewrite the first bullet point to mention that the targeted tile must be adjacent to an enemy
				entry.text = ::Reforged.Mod.Tooltips.parseString("Move to an adjacent tile that is adjacent to an enemy, ignoring [Zone of Control|Concept.ZoneOfControl] and [Spearwall|Skill+spearwall_effect]")
			}
		}

		foreach (index, entry in ret)
		{
			// We remove the warning about only being able to target tiles next to enemies as that information is now added to the first tooltip entry
			if (entry.id == 22 && entry.icon == "ui/tooltips/warning.png")
			{
				ret.remove(index);
				break;
			}
		}

		if (this.m.ActionPointCost != 0)
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("Costs " + ::MSU.Text.colorizeValue(this.m.ActionPointCost, {AddSign = true, InvertColor = true}) + " [Action Points|Concept.ActionPoints]"),
			});
		}

		if (this.m.FatigueCost != 0)
		{
			ret.push({
				id = 16,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("Costs " + ::MSU.Text.colorizeValue(this.m.FatigueCost, {AddSign = true, InvertColor = true}) + " [Fatigue|Concept.Fatigue]"),
			});
		}

		return ret;
	}
});
