::Hardened.HooksMod.hook("scripts/skills/racial/skeleton_racial", function(q) {
	// Public
	q.m.FatigueEffectMult <- 0.0;	// In Vanilla this is implemented via their faction stats instead

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.FatigueEffectMult != 1.0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Build up " + ::MSU.Text.colorizeMultWithText(this.m.FatigueEffectMult, {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Fatigue|Concept.Fatigue]"),
			});
		}

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		// We set the value here to improve performance and because we assume that this racial effect is never removed from characters
		// In Vanilla this property is defined in the Base Stat definitions of the respective entity types
		this.getContainer().getActor().getBaseProperties().FatigueEffectMult = this.m.FatigueEffectMult;
	}
});
