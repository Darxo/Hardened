::Hardened.HooksMod.hook("scripts/items/accessory/sergeant_badge_item", function(q) {
	q.m.ResolveModifier <- 10;

	q.onUpdateProperties = @() function( _properties )
	{
		this.accessory.onUpdateProperties(_properties);

		if (this.getContainer().getActor().getSkills().hasSkill("perk.rally_the_troops"))
		{
			_properties.Bravery += this.m.ResolveModifier;
		}
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		if (this.getContainer() == null) return ret;	// The item is not equipped to any actor at the moment
		if (this.getContainer().getActor().getSkills().hasSkill("perk.rally_the_troops")) return ret;

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.icon = "ui/tooltips/warning.png";
				entry.text = ::Reforged.Mod.Tooltips.parseString("Grants " + ::MSU.Text.colorizeValue(this.m.ResolveModifier, {AddSign = true}) + " [Resolve|Concept.Bravery] if you have [Rally|Perk+perk_rally_the_troops]");
			}
		}

		return ret;
	}
});
