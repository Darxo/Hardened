::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_robber", function(q) {
	// Public
	q.m.AvailableOneHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/boar_spear",
		"scripts/items/weapons/dagger",
		"scripts/items/weapons/falchion",
		"scripts/items/weapons/scramasax",
	]);
	q.m.AvailableTwoHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/hooked_blade",
		"scripts/items/weapons/warfork",
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
	}

	q.assignRandomEquipment = @(__original) function()
	{
		this.m.IsThrower = false;
		this.m.HasNet = false;
		__original();

		if (::Math.rand(1, 2) == 1)
		{
			::Hardened.util.replaceMainhand(this, this.m.AvailableOneHandedWeapons.roll());
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
			{
				this.getItems().equip(::new("scripts/items/tools/throwing_net"));	// A one-handed robber now always has a net
			}
		}
		else
		{
			::Hardened.util.replaceMainhand(this, this.m.AvailableTwoHandedWeapons.roll());
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag))
			{
				this.getItems().addToBag(::new(this.m.AvailableThrowingWeapons.roll()));	// A two-handed robber now always has throwing weapons
			}
		}
	}
});
