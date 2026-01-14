::Hardened.HooksMod.hook("scripts/items/ammo/legendary/quiver_of_coated_arrows", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AmmoWeight = 0.2;
	}

	// Overwrite, because we need to base the tooltip off of the ammo base class as it contains additional/changes ammo information
	q.getTooltip = @() function()
	{
		local ret = this.ammo.getTooltip();		// Reforged fetches the tooltip from quiver_of_coated_arrows instead but that one is missing our ammo related tooltips

		// We manually add the tooltip about the bleed that the vanilla coated arrows has, adjusted with nested tooltips
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/damage_received.png",
			text = "Inflicts " + ::MSU.Text.colorDamage(this.m.BleedDamage / 5) + ::Reforged.Mod.Tooltips.parseString(" stacks of [Bleeding|Skill+bleeding_effect]"),
		});

		return ret;
	}
});
