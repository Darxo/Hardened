::Hardened.HooksMod.hook("scripts/skills/actives/rf_net_pull_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.MaxRange = 3;	// In Reforged this is 2
	}

	q.getTooltip = @(__original) function()	// This will be redundant with the next Reforged update and must be removed then
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/vision.png")
			{
				entry.text = ::MSU.String.replace(entry.text, "]2[", "]3[", true);	// Adjust the range description to match the new range of net pull
				break;
			}
		}

		return ret;
	}
});
