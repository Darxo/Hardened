::Hardened.HooksMod.hook("scripts/skills/special/night_effect", function(q) {
	q.m.VisionModifier <- -3;	// In Vanilla this is -2

	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/vision.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.VisionModifier, {AddSign = true}) + " [Vision|Concept.SightDistance]");
			}
		}
		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		local oldVision = _properties.Vision;
		__original(_properties);
		_properties.Vision = oldVision;	// Prevent Vanilla from changing the Vision

		if (_properties.IsAffectedByNight)
		{
			_properties.Vision += this.m.VisionModifier;
		}
	}
});
