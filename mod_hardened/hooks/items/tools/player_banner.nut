::Hardened.HooksMod.hook("scripts/items/tools/player_banner", function(q) {
	// Public
	q.m.RangedDefenseModifier <- -5;

	q.create = @(__original) function()
	{
		__original();
		this.removeWeaponType(::Const.Items.WeaponType.Spear);
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.RangedDefenseModifier, {AddSign = true}) + " [Ranged Defense|Concept.RangeDefense]"),
		});

		return ret;
	}

	q.onUpdateProperties = @(__original) function(_properties)
	{
		__original(_properties);
		_properties.RangedDefense += this.m.RangedDefenseModifier;
	}
});
