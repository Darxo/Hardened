::Hardened.HooksMod.hook("scripts/contracts/contracts/return_item_contract", function(q) {
	q.m.HD_possibleItemNames <- [
		"Rare Coin Collection",
		"Ceremonial Staff",
		"Idol of Fertility",
		"Golden Talisman",
		"Tome of Arcane Knowledge",
		"Lockbox",
		"Demonic Statuette",
		"Crystal Skull",
		// Feat: Increase pool of possible item names
		"Ancestral Heirloom",
		"Black Mirror",
		"Engraved Chalice",
		"Ivory Chess Set",
		"Ivory Figurine",
		"Golden Signet Ring",
		"Ornate Astrolabe",
		"Ornate Casket",
		"Sealed Manuscript",
	];

	q.start = @(__original) { function start()
	{
		__original();

		// Feat: Make item name pool moddable
		this.m.Flags.set("Item", ::MSU.Array.rand(this.m.HD_possibleItemNames));
	}}.start;
});
