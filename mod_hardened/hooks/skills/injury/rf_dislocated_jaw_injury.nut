::Hardened.HooksMod.hook("scripts/skills/injury/rf_dislocated_jaw_injury", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/bravery.png")
			{
				entry.text = ::MSU.Text.colorizeMultWithText(this.m.BraveryMult) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery] during your [turn|Concept.Turn]");
				break;
			}
		}

		return ret;
	}

	// Overwrite, because we rework the effect of this injury
	q.onUpdate = @() function( _properties )
	{
		this.injury.onUpdate(_properties);

		if (this.getContainer().getActor().isActiveEntity())
		{
			_properties.BraveryMult *= this.m.BraveryMult;
		}
	}
});
