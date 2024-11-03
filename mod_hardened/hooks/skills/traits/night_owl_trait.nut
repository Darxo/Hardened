::Hardened.HooksMod.hook("scripts/skills/traits/night_owl_trait", function(q) {
	q.m.VisionModifier <- 2;	// In Vanilla this is 1

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/vision.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.VisionModifier, {AddSign = true}) + " [Vision|Concept.SightDistance] during Nighttime");
				break;
			}
		}

		return ret;
	}

	q.onUpdate = @(__original) function(_properties)
	{
		local oldVision = _properties.Vision;
		__original(_properties);
		_properties.Vision = oldVision;	// Prevent Vanilla from changing the Vision

		if (this.getContainer().hasSkill("special.night"))
		{
			_properties.Vision += this.m.VisionModifier;
		}
	}
});
