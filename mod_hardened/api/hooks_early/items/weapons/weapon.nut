::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	// Public
	q.m.HD_BaseDropChance <- 60;	// A weapon worn by an NPC must pass this random roll in order to be dropped

	// Overwrite, because we implement the value of condition-based items in a more moddable way
	q.getValue = @() function()
	{
		local value = this.item.getValue() * this.HD_getConditionMult();
		return ::Math.floor(value);
	}

	// Overwrite, because we simplify the conditions and make them more moddable
	// Differences are:
	// 	- We always drop weapons worn by players (just like Reforged)
	//	- Blacksmith no longer improves our odds of looting enemy Weapons
	//	- Weapons with 11 or less Condition on enemies can now drop
	//	- We add this.m.HD_BaseDropChance to make the random roll moddable
	//	- Throwing Weapons no longer need to be equipped or missing an ammunition to be eligable for dropping
	q.isDroppedAsLoot = @() function()
	{
		if (!this.item.isDroppedAsLoot()) return false;

		local isPlayer = this.m.LastEquippedByFaction == ::Const.Faction.Player || !::MSU.isNull(this.getContainer()) && this.getContainer().getActor() != null && ::MSU.isKindOf(this.getContainer().getActor(), "player");

		if (isPlayer) return true;	// We always drop weapons worn by players (just like Reforged)
		if (this.isItemType(::Const.Items.ItemType.Named)) return true;
		if (this.isItemType(::Const.Items.ItemType.Legendary)) return true;

		// Random Chance-Based drop
		local isLucky = !::Tactical.State.isScenarioMode() && ::World.Assets.getOrigin().isDroppedAsLoot(this);
		if (isLucky) return true;	// If our scenario randomly decides it so, we will skip the chance based roll

		return ::Math.rand(1, 100) <= this.m.HD_BaseDropChance;
	}
});
