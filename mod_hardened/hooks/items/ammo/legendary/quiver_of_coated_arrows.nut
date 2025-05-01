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
		foreach (entry in ret)
		{
			if (entry.id == 7)
			{
				// Change the bleeding related entry to multiple stacks of bleeding instead of 2 turns of bleeding
				// because of different bleeding mechanics in Reforged
				entry.text = "Inflicts " + ::MSU.Text.colorDamage(this.m.BleedDamage / 5) + ::Reforged.Mod.Tooltips.parseString(" stacks of [Bleeding|Skill+bleeding_effect]");
				break;
			}
		}
		return ret;
	}
});
