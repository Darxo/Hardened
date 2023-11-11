::Hardened.HooksMod.hook("scripts/items/armor/armor", function(q) {
	q.onUnequip = @(__original) function()
	{
		if (this.getUpgrade() != null) this.setToBeRepaired(true);	  // If an armor piece has an attachement you basically always want it repaired
		if (this.isItemType(::Const.Items.ItemType.Legendary)) this.setToBeRepaired(true);
		__original();
	}
});
