::Hardened.HooksMod.hook("scripts/items/armor_upgrades/unhold_fur_upgrade", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ConditionModifier = 15;	// In Vanilla this is 10
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 14 && entry.icon == "ui/icons/armor_body.png")
			{
				entry.text = ::MSU.Text.colorizeValue(this.m.ConditionModifier, {AddSign = true}) + " Condition";
				break;
			}
		}

		return ret;
	}
});
