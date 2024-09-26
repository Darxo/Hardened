::Hardened.HooksMod.hook("scripts/events/event", function(q) {
	// Refactors uses of "Max Fatigue" into "Stamina" for all list entries used in events
	q.getUIList = @(__original) function()
	{
		local ret = __original();

		if (ret.len() != 0)
		{
			foreach (listEntry in ret[0].items)
			{
				if (!("text" in listEntry)) continue;
				listEntry.text = ::MSU.String.replace(listEntry.text, "Max Fatigue", "Stamina", true);
			}
		}

		return ret;
	}
});
