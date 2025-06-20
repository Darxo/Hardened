::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bulwark", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsHidingIconMini = true;	// We hide the mini-icon to reduce bloat during battle as its existance conveys no situation-specific information
	}

	// Overwrite, because we have a completely different effect
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+" + this.getBonus()) + " [Resolve|Concept.Bravery]"),
		});

		return ret;
	}

	// Overwrite, because we grant a flat bonus instead of a bonus that only works during morale checks
	q.onUpdate = @() function( _properties )
	{
		_properties.Bravery += this.getBonus();
	}
});
