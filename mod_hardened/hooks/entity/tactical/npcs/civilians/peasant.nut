// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/peasant", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([	// 20 - 50
			[12, "scripts/items/armor/tattered_sackcloth"],
			[12, "scripts/items/armor/sackcloth"],
			[60, "scripts/items/armor/linen_tunic"],
			[12, "scripts/items/armor/thick_tunic"],
			[6, "scripts/items/armor/apron"],
			[6, "scripts/items/armor/butcher_apron"],
		]);

		this.m.ChanceForNoHelmet = 70;	// Vanilla: 67
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 20 - 40
			[12, "scripts/items/helmets/headscarf"],
			[12, "scripts/items/helmets/hood"],
			[12, "scripts/items/helmets/straw_hat"],
			[8, "scripts/items/helmets/feathered_hat"],
		]);

		this.m.ChanceForNoWeapon = 30;	// Vanilla: 40
		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/butchers_cleaver"],
			[12, "scripts/items/weapons/knife"],
			[12, "scripts/items/weapons/pickaxe"],
			[12, "scripts/items/weapons/pitchfork"],
			[12, "scripts/items/weapons/wooden_flail"],
			[24, "scripts/items/weapons/wooden_stick"],		// Higher chance because they might have just picked it up off the ground
		]);
	}
});
