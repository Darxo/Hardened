::Hardened.HooksMod.hook("scripts/items/helmets/faction_helm", function(q) {
	q.m.HD_BraveryModifier <- 10;	// This much Resolve is added to the character, while this item is equipped

	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 5000;			// In Vanilla this is 4000
		this.m.ConditionMax = 300; 		// In Vanilla this is -320
		this.m.StaminaModifier = -23; 	// In Vanilla this is -21
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.getBraveryModifier() != 0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::MSU.Text.colorizeValue(this.getBraveryModifier(), {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]"),
			});
		}

		return ret;
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		__original(_properties);

		_properties.Bravery += this.getBraveryModifier();
	}

// New Functions
	q.getBraveryModifier <- function()
	{
		return this.m.HD_BraveryModifier;
	}
});
