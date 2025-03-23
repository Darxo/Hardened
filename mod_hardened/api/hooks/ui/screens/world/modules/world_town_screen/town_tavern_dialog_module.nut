::Hardened.HooksMod.hook("scripts/ui/screens/world/modules/world_town_screen/town_tavern_dialog_module", function(q) {
	q.onQueryRumor = @(__original) function()
	{
		local ret = __original();

		ret.LeftInfo <- this.generateLeftInfo();	// We add this new entry, because this text contains the current rumor price and needs to update

		return ret;
	}

	q.queryData = @(__original) function()
	{
		local ret = __original();

		ret.LeftInfo = this.generateLeftInfo();	// We replace the vanilla LeftInfo with one that actually uses the vanilla getter

		return ret;
	}

// New Functions
	// Return the text shown in the left half, describing the button and the cost of it
	// Text is vanilla, main difference is that we use the vanilla RumorPrice getter instead of an hard-coded price
	q.generateLeftInfo <- function()
	{
		return "Pay for a round to get the patrons to share more news and rumors ([img]gfx/ui/tooltips/money.png[/img]" + this.m.Tavern.getRumorPrice() + ").";
	}
});
