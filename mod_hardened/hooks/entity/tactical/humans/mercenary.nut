::Hardened.HooksMod.hook("scripts/entity/tactical/humans/mercenary", function(q) {
	q.m.HD_BandageChance <- 30;

	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		this.paintShieldsInCompanyColors();

		if (::Math.rand(1, 100) <= this.m.HD_BandageChance && this.getItems().hasEmptySlot(::Const.ItemSlot.Bag))
		{
			this.getItems().addToBag(::new("scripts/items/accessory/bandage_item"));
		}
	}
});
