::Hardened.HooksMod.hook("scripts/items/special/golden_goose_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// The Hardened price rework overwrites this items hard-coded pricing
		// So we give it the Loot itemtype so that its sell price is normal as expected
		this.addItemType(::Const.Items.ItemType.Loot);
	}
});

