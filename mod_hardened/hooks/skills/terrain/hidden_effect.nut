::Hardened.HooksMod.hook("scripts/skills/terrain/hidden_effect", function(q) {
	q.m.RangedDefenseModifier <- 10;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.RangedDefenseModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.RangedDefenseModifier, {AddSign = true}) + " [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		return ret;
	}

	// Revert any changes done to MeleeSkillMult
	q.onUpdate = @(__original) function(_properties)
	{
		__original(_properties);
		_properties.RangedDefense += this.m.RangedDefenseModifier;
	}
});
