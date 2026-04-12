::Hardened.HooksMod.hook("scripts/skills/racial/ghost_racial", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10)
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	// Overwrite, because this racial effect no longer grants its defenses inherently
	q.onBeingAttacked = @() { function onBeingAttacked( _attacker, _skill, _properties ) {}}.onBeingAttacked;

	q.onAdded = @(__original) function()
	{
		__original();

		// Since this racial is never meant to be removed and only exists on NPCs, we dont need to handle the removal of this perk
		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_hd_ethereal", function(o) {
			o.m.IsRefundable = false;
			o.m.IsSerialized = false;
		}));
	}
});
