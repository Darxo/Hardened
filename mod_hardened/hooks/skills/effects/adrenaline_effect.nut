::Hardened.HooksMod.hook("scripts/skills/effects/adrenaline_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Name = "Adrenaline Rush";		// Vanilla: Adrenaline
	}

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = ::MSU.Text.colorizeValue(2000, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [$ $|Concept.Readiness]"),
		});

		return ret;
	}}.getTooltip;
});
