::Hardened.HooksMod.hook("scripts/items/accessory/poison_item", function(q) {	// Goblin Poison
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;		// Vanilla: 100

		this.m.SlotType = ::Const.ItemSlot.Offhand;
		this.m.ItemType = ::Const.Items.ItemType.Tool;
	}
});
