::Hardened.HooksMod.hook("scripts/skills/actives/rf_pummel_skill", function(q) {
	q.m.ActionPointCostMult <- 1.0;
	q.m.HD_FatigueCostMult <- 1.5;	// Vanilla already has this field but I want this multiplier to show up separately

	q.create = @(__original) function()
	{
		__original();
		this.m.Description += "\nThis skill's base cost matches that of the attack it triggers during execution.";
		this.m.ActionPointCost = 0;		// This is now assigned dynamically to the cost of the AOO
		this.m.FatigueCost = 0;			// This is now assigned dynamically to the cost of the AOO
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/warning.png")
			{
				entry.text = ::MSU.String.replace(entry.text, "two-handed ", "", true);
				break;
			}
		}

		if (this.m.ActionPointCostMult != 1.0)
		{
			ret.push({
				id = 14,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("Costs " + ::MSU.Text.colorizeMultWithText(this.m.ActionPointCostMult, {InvertColor = true}) + " [Action Points|Concept.ActionPoints]"),
			});
		}

		if (this.m.HD_FatigueCostMult != 1.0)
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("Costs " + ::MSU.Text.colorizeMultWithText(this.m.HD_FatigueCostMult, {InvertColor = true}) + " [Fatigue|Concept.Fatigue]"),
			});
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		local attack = this.getValidAttack();
		if (attack != null)
		{
			// Now Pummel will have a base costs as the skill it will execute
			this.setBaseValue("ActionPointCost", attack.getBaseValue("ActionPointCost"));
			this.setBaseValue("FatigueCost", attack.getBaseValue("FatigueCost"));
		}
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		this.m.ActionPointCost *= this.m.ActionPointCostMult;
		this.m.FatigueCost *= this.m.HD_FatigueCostMult;
	}
});
