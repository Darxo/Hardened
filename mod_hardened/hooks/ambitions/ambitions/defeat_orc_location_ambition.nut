::Hardened.HooksMod.hook("scripts/ambitions/ambitions/defeat_orc_location_ambition", function(q) {
	q.m.HD_TempNestedItem <- null;	// temporary item holder so that our reference item survives long enough for it to show up in a nested tooltip

	q.create = @(__original) { function create()
	{
		__original();
		this.m.RewardTooltip = "";	// We create the rewards dynamically
	}}.create;

	q.getButtonTooltip = @(__original) { function getButtonTooltip()
	{
		local ret = __original();

		this.m.HD_TempNestedItem = ::new("scripts/items/accessory/orc_trophy_item");
		ret.push({
			id = 10,
			type = "text",
			icon = ::Reforged.NestedTooltips.getNestedItemImage(this.m.HD_TempNestedItem),
			text = ::Reforged.Mod.Tooltips.parseString(format("Gain [$ $|Item+%s]", this.m.HD_TempNestedItem.ClassName)),
		});

		return ret;
	}}.getButtonTooltip;
});
