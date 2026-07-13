// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_treasure_hunter", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Since Vanilla inherits from zombie_knight, it also inherits our equipment loadout assigned there
		// So we need to overwrite it again in this scripts create
		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/oriental/stitched_nomad_armor"],
			[12, "scripts/items/armor/oriental/leather_nomad_robe"],
			[12, "scripts/items/armor/oriental/nomad_robe"],
			[12, "scripts/items/armor/oriental/thick_nomad_robe"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/oriental/nomad_head_wrap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/shamshir"],
			[12, "scripts/items/weapons/oriental/heavy_southern_mace"],
		]);

		this.m.OffhandWeightContainer = null;
	}
});
