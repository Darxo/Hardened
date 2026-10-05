::Hardened.HooksMod.hook("scripts/items/accessory/spider_poison_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;		// Vanilla: 150

		this.m.SlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Tool;
	}
});
