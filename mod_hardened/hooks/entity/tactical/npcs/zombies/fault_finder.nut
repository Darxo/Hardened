// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/fault_finder", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/oriental/fault_finder_robes"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/golems/fault_finder_book_head"],
			[12, "scripts/items/helmets/golems/fault_finder_eye_mask"],
			[12, "scripts/items/helmets/golems/fault_finder_facewrap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/knife"],
			[12, "scripts/items/weapons/butchers_cleaver"],
		]);
	}
});
