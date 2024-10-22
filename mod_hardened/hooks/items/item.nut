::Hardened.HooksMod.hookTree("scripts/items/item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Condition = ::Math.minf(this.m.Condition, this.m.ConditionMax);	// Prevent Condition from ever being larger than ConditionMax
	}

	// We replace the vanilla weight tooltip on all items with a more descriptive and hyperlinked term
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if ("text" in entry)
			{
				if (entry.text.find("Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]") != null)	// Regular weight tooltip line for items
				{
					if (this.getWeight() == 0)	// Since we made Vanilla produce weight tooltips for weapons even while the item has no weight, we need to clean them up now
					{
						ret.remove(index);
					}
					else
					{
						entry.icon = "ui/icons/bag.png";
						entry.text = ::Reforged.Mod.Tooltips.parseString("[Weight|Concept.Weight]: ") + ::MSU.Text.colorNegative(this.getWeight());
					}
					break;
				}
				else if (entry.text.find("[/color] Maximum Fatigue") != null)	// Weight tooltip line for attachements
				{
					entry.icon = "ui/icons/bag.png";
					entry.text = ::MSU.Text.colorNegative("+" + this.getWeight()) + ::Reforged.Mod.Tooltips.parseString(" [Weight|Concept.Weight]");
					break;
				}
			}
		}

		return ret;
	}
});

