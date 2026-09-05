::Hardened.HooksMod.hook("scripts/items/armor_upgrades/light_gladiator_upgrade", function(q) {
	q.m.RangedDefenseModifier <- -5;

	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;					// Vanilla: 200
		this.m.ConditionModifier = 50;		// Vanilla: 60
		this.m.StaminaModifier = 3;			// Vanilla: 4
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.RangedDefenseModifier != 0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::MSU.Text.colorizeValue(this.m.RangedDefenseModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [$ $|Concept.RangeDefense]"),
			});
		}

		return ret;
	}

	q.onArmorTooltip = @(__original) function( _result )
	{
		__original(_result);
		_result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = ::MSU.Text.colorizeValue(this.m.RangedDefenseModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [$ $|Concept.RangeDefense]"),
		});
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.RangedDefense += this.m.RangedDefenseModifier;
	}
});
