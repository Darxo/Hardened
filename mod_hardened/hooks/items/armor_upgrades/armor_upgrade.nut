::Hardened.HooksMod.hookTree("scripts/items/armor_upgrades/armor_upgrade", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if ("text" in entry && entry.text.find("[/color] Durability") != null)
			{
				// Vanilla Fix: condition values not using the ConditionModifier member
				entry.text = ::MSU.Text.colorizeValue(this.m.ConditionModifier, {AddSign = true})  + " Condition";
			}
		}

		return ret;
	}
});
