::Hardened.HooksMod.hook("scripts/skills/skill", function(q) {
	q.isDuelistValid = @() function()
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhandItem == null) return false;
		if (mainhandItem.isItemType(::Const.Items.ItemType.OneHanded) == false) return false;

		return true;
	}
});
