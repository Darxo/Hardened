::Hardened.HooksMod.hook("scripts/items/accessory/legendary/cursed_crystal_skull", function(q) {
	q.m.ThreatModifier <- 10;	// This is currently only used for the tooltips, changing it does not change the actual effect yet

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
});
