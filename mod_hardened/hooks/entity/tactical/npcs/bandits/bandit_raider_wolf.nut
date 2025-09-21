// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_raider_wolf", function(q) {
	// Hardened Functions
	q.create = @(__original) function()
	{
		__original();

		this.m.XP = 250;	// Bandit Raider: 240
	}

	// Overwrite, because we use the same logic as the base class
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.bandit_raider.assignRandomEquipment();
	}}.assignRandomEquipment;

// Hardened Functions
	// Assign Head and Body armor to this character
	q.HD_assignArmor = @(__original) function()
	{
		__original();

		local bodyItem = this.getBodyItem();
		if (bodyItem != null)
		{
			bodyItem.setUpgrade(::new("scripts/items/armor_upgrades/direwolf_pelt_upgrade"));
		}
	}
});
