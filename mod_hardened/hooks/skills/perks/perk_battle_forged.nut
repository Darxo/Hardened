::Hardened.HooksMod.hook("scripts/skills/perks/perk_battle_forged", function(q) {

	q.getTooltip = @(__original) function()
	{
		local ret = __original()

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/reach.png")
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	q.getReachIgnore = @() function()
	{
		return 0;	// Do nothing: Battle Forged no longer grants reach ignore
	}
});
