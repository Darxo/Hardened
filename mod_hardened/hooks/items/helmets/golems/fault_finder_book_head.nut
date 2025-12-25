::Hardened.HooksMod.hook("scripts/items/helmets/golems/fault_finder_book_head", function(q) {
	// Public
	q.m.HD_BraveryModifier <- 5;

	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 200;				// Vanilla: 0
		this.m.ConditionMax = 10; 		// Vanilla: 10
		this.m.StaminaModifier = -3; 	// Vanilla: 0
		this.m.Vision = -1;				// Vanilla: 0
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
