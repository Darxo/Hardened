::Hardened.HooksMod.hook("scripts/items/shields/shield", function(q) {
	q.m.HD_ConditionThresholdForDrop <- 0.25;	// A shield worn by an NPC must have its current condition % be at least this, so that it is allowed to drop
	q.m.HD_BaseDropChance <- 90;	// A shield worn by an NPC must pass this random roll in order to be dropped

	// Overwrite, because we implement the value of condition-based items in a more moddable way
	q.getValue = @() function()
	{
		local value = this.item.getValue() * this.HD_getConditionMult();
		return ::Math.floor(value);
	}

	// Overwrite, because we simplify the conditions and make them more moddable
	// Differences are:
	// 	- We only consider shields destroyed when they have 0 Condition (up from 6 or less)
	//	- We add this.m.HD_ConditionThresholdForDrop to make the threshold moddable
	//	- We add this.m.HD_BaseDropChance to make the random roll moddable
	//	- Named/Legendary Items ignore the HD_ConditionThresholdForDrop roll and always drop
	q.isDroppedAsLoot = @() function()
	{
		if (!this.item.isDroppedAsLoot()) return false;

		local isBlacksmithed = !::Tactical.State.isScenarioMode() && ::World.Assets.m.IsBlacksmithed;
		local isPlayer = this.m.LastEquippedByFaction == ::Const.Faction.Player || this.getContainer() != null && ::MSU.isKindOf(this.getContainer().getActor(), "player");

		if (this.getCondition() <= 0 && isPlayer && !isBlacksmithed) return false;		// The shield is completely destroyed beyond repair

		if (isPlayer) return true;	// shields from player always drop if not fully destroyed

		if (this.isItemType(::Const.Items.ItemType.Named)) return true;
		if (this.isItemType(::Const.Items.ItemType.Legendary)) return true;

		// Check for whether the condition threshold is met
		if (this.getCondition() / this.getConditionMax() < this.m.HD_ConditionThresholdForDrop) return false;

		// Random Chance-Based drop
		local isLucky = !::Tactical.State.isScenarioMode() && ::World.Assets.getOrigin().isDroppedAsLoot(this);
		if (isLucky) return true;	// If our scenario randomly decides it so, we will skip the chance based roll
		if (isBlacksmithed) return true;	// Blacksmith skips the chance base droll

		return ::Math.rand(1, 100) <= this.m.HD_BaseDropChance;
	}
});
