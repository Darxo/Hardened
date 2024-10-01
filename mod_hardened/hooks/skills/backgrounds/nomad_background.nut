::Hardened.HooksMod.hook("scripts/skills/backgrounds/nomad_background", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10)
			{
				ret.remove(index);	// Remove entry about pocket sand
				break;
			}
		}

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		__original();
		this.getContainer().removeByID("actives.throw_dirt");	// Remove the skill added by reforged
	}
});
