::Hardened.HooksMod.hook("scripts/items/accessory/sergeant_badge_item", function(q) {
	q.onUpdateProperties = @() function( _properties )
	{
		this.accessory.onUpdateProperties(_properties);

		if (this.getContainer().getActor().getSkills().hasSkill("perk.rally_the_troops"))
		{
			_properties.Bravery += 10;
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
				entry.icon = "ui/icons/warning.png";
				entry.text = "This character requires the perk \'Rally the Troops\' to receive a bonus from this item";
			}
		}

		return ret;
	}
});
