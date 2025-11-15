::Hardened.HooksMod.hook("scripts/items/armor_upgrades/unhold_fur_upgrade", function(q) {
	q.m.HD_DamageReceivedRangedMult <- 0.8;

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
			}
			else if (entry.id == 7 && entry.icon == "ui/icons/special.png")
			{
				entry.icon = "/ui/icons/ranged_defense.png";
				entry.text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.HD_DamageReceivedRangedMult, {InvertColor = true}) + " Ranged Damage from Body Hits";
			}
		}

		return ret;
	}

	q.onArmorTooltip = @(__original) function( _result )
	{
		__original(_result);

		foreach (entry in _result)
		{
			if (entry.id == 7 && entry.icon == "ui/icons/special.png")
			{
				entry.icon = "/ui/icons/ranged_defense.png";
				entry.text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.HD_DamageReceivedRangedMult, {InvertColor = true}) + " Ranged Damage from Body Hits";
			}
		}
	}
});
