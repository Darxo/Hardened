::Hardened.HooksMod.hook("scripts/items/item", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		this.m.Condition = ::Math.minf(this.m.Condition, this.m.ConditionMax);	// Prevent Condition from ever being larger than ConditionMax
	}
});

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

		foreach (entry in ret)
		{
			if ("text" in entry)
			{
				if (entry.text.find("Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]") != null)	// Regular weight tooltip line for items
				{
					entry.icon = "ui/icons/bag.png";
					entry.text = ::Reforged.Mod.Tooltips.parseString("[Weight|Concept.Weight]: ") + ::MSU.Text.colorNegative(this.getWeight());
				}
				else if (entry.text.find("[/color] Maximum Fatigue") != null)	// Weight tooltip line for attachements
				{
					entry.icon = "ui/icons/bag.png";
					entry.text = ::MSU.Text.colorNegative("+" + this.getWeight()) + ::Reforged.Mod.Tooltips.parseString(" [Weight|Concept.Weight]");
				}
			}
		}

		return ret;
	}
});

