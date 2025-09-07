::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_bandit", function(q) {
	// Public
	q.m.AvailableOneHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/boar_spear",
		"scripts/items/weapons/rondel_dagger",
		"scripts/items/weapons/arming_sword",
		"scripts/items/weapons/scramasax",
	]);
	q.m.AvailableTwoHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/rf_reinforced_wooden_poleflail",
		"scripts/items/weapons/pike",
		"scripts/items/weapons/spetum",
	]);
	q.m.AvailableThrowingWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/javelin",
		"scripts/items/weapons/throwing_axe",
	]);

	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		if (::Math.rand(1, 2) == 1)
		{
			::Hardened.util.replaceMainhand(this, this.m.AvailableOneHandedWeapons.roll());
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
			{
				this.getItems().equip(::new("scripts/items/tools/throwing_net"));	// A one-handed bandit now always has a net
			}
		}
		else
		{
			::Hardened.util.replaceMainhand(this, this.m.AvailableTwoHandedWeapons.roll());
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag))
			{
				this.getItems().addToBag(::new(this.m.AvailableThrowingWeapons.roll()));	// A two-handed bandit now always has throwing weapons
			}
		}
	}
});
