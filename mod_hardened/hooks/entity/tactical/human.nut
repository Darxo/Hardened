::Hardened.Global.lastGeneratedNames <- array(5, "");	// Array of the last 5 generated names from the generateName of a human

::Hardened.HooksMod.hookTree("scripts/entity/tactical/human", function(q) {
	// We reroll generateName until it produces a name that has not been rolled by any generateName function the last 5 times

	q.generateName = @(__original) function()
	{
		local uniqueName = "";

		for (local i = 0; i < 10; ++i)	// We try 10 times to find a unique name that hasn't been chosen the last 5 times
		{
			uniqueName = __original();
			if (::Hardened.Global.lastGeneratedNames.find(uniqueName) == null)
			{
				break;
			}
		}

		::Hardened.Global.lastGeneratedNames.insert(0, uniqueName);
		::Hardened.Global.lastGeneratedNames.pop();

		return uniqueName;
	}
});

::Hardened.HooksMod.hook("scripts/entity/tactical/human", function(q) {
	/// Return a randomly generated name for this human
	q.generateName <- function()
	{
		return "";
	}
});
