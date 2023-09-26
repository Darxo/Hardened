::mods_hookBaseClass("skills/skill", function(o) {
	o = o[o.SuperName];

	o.m.IsIgnoringArmorReduction <- false;

	o.isDuelistValid = function()
	{
		local mainhandItem = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhandItem == null) return false;
		if (mainhandItem.isItemType(::Const.Items.ItemType.OneHanded) == false) return false;

        return true;
	}
});
