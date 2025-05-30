::Hardened.HooksMod.hook("scripts/items/armor_upgrades/hyena_fur_upgrade", function(q) {
	q.m.InitiativeMult <- 1.1;	// The Initiative Multiplier granted by this upgrade

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 15 && entry.icon == "ui/icons/initiative.png")
			{
				if (this.m.InitiativeMult == 1.0)
				{
					ret.remove(index);
				}
				else
				{
					entry.text =  ::MSU.Text.colorizeMultWithText(this.m.InitiativeMult) + ::Reforged.Mod.Tooltips.parseString(" [Initiative|Concept.Initiative]");
				}

				break;
			}
		}

		return ret;
	}

	q.onArmorTooltip = @(__original) function( _result )
	{
		__original(_result);

		foreach (index, entry in _result)
		{
			if (entry.id == 15 && entry.icon == "ui/icons/initiative.png")
			{
				if (this.m.InitiativeMult == 1.0)
				{
					_result.remove(index);
				}
				else
				{
					entry.text =  ::MSU.Text.colorizeMultWithText(this.m.InitiativeMult) + ::Reforged.Mod.Tooltips.parseString(" [Initiative|Concept.Initiative]");
				}

				break;
			}
		}
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		// We revert the initiative bonus granted by vanilla
		local oldInitiative = _properties.Initiative;
		__original(_properties);
		_properties.Initiative = oldInitiative;

		_properties.InitiativeMult *= this.m.InitiativeMult;
	}
});
