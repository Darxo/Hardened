::Hardened.HooksMod.hook("scripts/items/accessory/undead_trophy_item", function(q) {
	q.m.HD_BraveryModifier <- 5;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.HD_BraveryModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::MSU.Text.colorizeValue(this.m.HD_BraveryModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]"),
			});
		}

		return ret;
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		__original(_properties);

		_properties.Bravery += this.m.HD_BraveryModifier;
	}
});
