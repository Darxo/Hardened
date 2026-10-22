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

	q.createScreens = @(__original) { function createScreens()
	{
		__original();

		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "Necromancer" && ::Hooks.hasMod("mod_crock_pot"))
			{
				// Feat: When Crock Pot is present, we spawn the hooded man at tier 2 and the necromancer only at tier 3
				screen.Options[0].getResult = function()
				{
					if (this.Contract.HD_getDifficultyTier() <= 2)
					{
						::Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = ::Const.World.Spawn.Troops.CP_HoodedMan,
						});
					}
					else
					{
						::Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = ::Const.World.Spawn.Troops.Necromancer,
						});
					}

					this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
					return 0;
				}
			}
		}
	}}.createScreens;
});
