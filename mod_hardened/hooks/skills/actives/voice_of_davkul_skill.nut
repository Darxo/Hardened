::Hardened.HooksMod.hook("scripts/skills/actives/voice_of_davkul_skill", function(q) {
	// Overwrite, because we streamline the vanilla tooltip wording
	q.getTooltip = @() function()
	{
		local ret = this.getDefaultUtilityTooltip();

		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Make every " + ::MSU.Text.colorNeutral("Cultist") + " on the battlefield recover " + ::MSU.Text.colorPositive(10) + ::Reforged.Mod.Tooltips.parseString(" [Fatigue|Concept.Fatigue]"),
			}
		]);

		return ret;
	}
});
