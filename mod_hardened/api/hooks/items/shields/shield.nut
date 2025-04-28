::Hardened.HooksMod.hook("scripts/items/shields/shield", function(q) {
	q.m.HD_BraveryModifier <- 0;	// This much Resolve is added to the character, while this shield is equipped

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

	// Change the variant of this shield into one based on the passed player banner id
	q.paintInCompanyColors <- function( _bannerID )		// virtual
	{
	}
});
