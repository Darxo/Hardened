::Hardened.HooksMod.hook("scripts/ambitions/ambitions/battle_standard_ambition", function(q) {
	q.m.HD_TempNestedItem <- null;	// temporary item holder so that our reference item survives long enough for it to show up in a nested tooltip

	q.create = @(__original) { function create()
	{
		__original();
		this.m.RewardTooltip = "";	// We create the rewards dynamically
	}}.create;

	q.getButtonTooltip = @(__original) { function getButtonTooltip()
	{
		local ret = __original();

		this.m.HD_TempNestedItem = ::new("scripts/items/tools/player_banner");
		this.m.HD_TempNestedItem.setVariant(::World.Assets.getBannerID());
		ret.push({
			id = 10,
			type = "text",
			icon = ::Reforged.NestedTooltips.getNestedItemImage(this.m.HD_TempNestedItem),
			text = ::Reforged.Mod.Tooltips.parseString(format("Gain [$ $|Item+%s]", this.m.HD_TempNestedItem.ClassName)),	// This is the only way to display a nested tooltip for this banner. Unfortunately it will only display it in the default coloring.
		});

		ret.push({
			id = 15,
			type = "text",
			icon = "ui/icons/asset_money.png",
			text = ::MSU.Text.colorizeValue(-1000, {AddSign = true}) + " Crowns",
		});

		return ret;
	}}.getButtonTooltip;


	q.onUpdateScore = @(__original) function()
	{
		if (::World.Assets.getBusinessReputation() < 600) return;

		__original();
	}
});
