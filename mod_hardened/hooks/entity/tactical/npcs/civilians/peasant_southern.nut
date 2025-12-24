// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/peasant_southern", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([	// 20 - 50
			[12, "scripts/items/armor/tattered_sackcloth"],
			[12, "scripts/items/armor/sackcloth"],
			[12, "scripts/items/armor/linen_tunic"],
			[60, "scripts/items/armor/oriental/cloth_sash"],
			[6, "scripts/items/armor/apron"],
			[6, "scripts/items/armor/butcher_apron"],
		]);

		this.m.ChanceForNoHelmet = 50;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 30
			[12, "scripts/items/helmets/oriental/southern_head_wrap"],
			[12, "scripts/items/helmets/oriental/nomad_head_wrap"],
		]);

		this.m.ChanceForNoWeapon = 30;	// Vanilla: 40
		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/butchers_cleaver"],
			[12, "scripts/items/weapons/knife"],
			[12, "scripts/items/weapons/pickaxe"],
			[12, "scripts/items/weapons/pitchfork"],
			[12, "scripts/items/weapons/wooden_stick"],
		]);
	}
});
