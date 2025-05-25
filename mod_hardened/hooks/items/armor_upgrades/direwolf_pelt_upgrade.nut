::Hardened.HooksMod.hook("scripts/items/armor_upgrades/direwolf_pelt_upgrade", function(q) {
	q.m.ThreatModifier <- 5;	// This is currently only used for the tooltips, changing it does not change the actual effect yet

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 15 && entry.icon == "ui/icons/special.png")
			{
				entry.icon = "ui/icons/kills.png";
				entry.text = ::MSU.Text.colorizeValue(this.m.ThreatModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Threat|Concept.Threat]");
				break;
			}
		}

		return ret;
	}

	q.onArmorTooltip = @(__original) function( _result )
	{
		__original(_result);

		foreach (entry in _result)
		{
			if (entry.id == 15 && entry.icon == "ui/icons/special.png")
			{
				entry.icon = "ui/icons/kills.png";
				entry.text = ::MSU.Text.colorizeValue(this.m.ThreatModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Threat|Concept.Threat]");
				break;
			}
		}
	}
});
