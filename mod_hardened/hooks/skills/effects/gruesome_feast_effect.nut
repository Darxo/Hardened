::Hardened.HooksMod.hook("scripts/skills/effects/gruesome_feast_effect", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.getContainer().getActor().getSize() > 1)
		{
			// We reduced the base Melee Defense of small Ghouls by 10, but that effects all sizes of Ghouls
			// Therefor, we offset that change within this effect
			_properties.MeleeDefense += 10;
		}
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 12 && icon == "ui/icons/melee_defense.png")
			{
				local size = this.getContainer().getActor().getSize();
				if (size == 2)
				{
					entry.text = ::MSU.Text.colorPositive("+15") + ::Reforged.Mod.Tooltips.parseString(" [Melee Defense|Concept.MeleeDefense]");
				}
				else if (size == 3)
				{
					entry.text = ::MSU.Text.colorPositive("+20") + ::Reforged.Mod.Tooltips.parseString(" [Melee Defense|Concept.MeleeDefense]");
				}
				break;
			}
		}

		return ret;
	}
});
