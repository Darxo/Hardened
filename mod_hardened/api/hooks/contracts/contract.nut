::Hardened.HooksMod.hookTree("scripts/contracts/contract", function(q) {
	// We make sure that all screens of all contracts contain at least an empty start() function
	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (!("start" in screen))
			{
				screen.start <- function() {};
			}
		}
	}
});
