::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_killer", function(q) {
	// Public
	q.m.AvailableOneHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/boar_spear",
		"scripts/items/weapons/rondel_dagger",
		"scripts/items/weapons/arming_sword",
	]);
	q.m.AvailableTwoHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/billhook",
		"scripts/items/weapons/rf_poleflail",
	]);
	q.m.AvailableThrowingWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/javelin",
		"scripts/items/weapons/throwing_axe",
	]);

	q.onInit = @(__original) function()
	{
		__original();
		local tattoo_head = this.getSprite("tattoo_head");
		tattoo_head.setBrush("warpaint_0" + ::Math.rand(2, 3) + "_head");
		tattoo_head.Visible = true;

		this.m.HasNet = false;
		this.m.IsRegularThrower = false;
		this.m.IsSpearThrower = false;	// Killer never spawn with throwing spears (down from 12,5% chance in Reforged)
	}

	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		if (::Math.rand(1, 2) == 1)
		{
			::Hardened.util.replaceMainhand(this, this.m.AvailableOneHandedWeapons.roll());
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
			{
				this.getItems().equip(::new("scripts/items/tools/throwing_net"));	// A one-handed killer now always has a net
			}
		}
		else
		{
			::Hardened.util.replaceMainhand(this, this.m.AvailableTwoHandedWeapons.roll());
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag))
			{
				this.getItems().addToBag(::new(this.m.AvailableThrowingWeapons.roll()));	// A two-handed killer now always has throwing weapons
			}
		}
	}
});
