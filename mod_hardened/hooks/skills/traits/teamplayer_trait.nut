::Hardened.HooksMod.hook("scripts/skills/traits/teamplayer_trait", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.text.find("lower chance to inflict") != null)
			{
				entry.text = ::MSU.Text.colorizeMultWithText(0.5, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Hitchance|Concept.Hitchance] against allies from your faction");
			}
		}
		return ret;
	}
});
