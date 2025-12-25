::Hardened.HooksMod.hook("scripts/items/helmets/helmet", function(q) {
	// Public
	// A helmet worn by a Player is guaranteed to drop, if it has at least this much condition
	q.m.HD_MinConditionForPlayerDrop <- 16;
	// A helmet worn by an NPC must have its current condition be at least this, so that it is allowed to drop
	q.m.HD_MinConditionForDrop <- 31;
	// A helmet worn by an NPC must have its current condition pct be at least this, so that it is allowed to drop
	q.m.HD_ConditionThresholdForDrop <- 0.25;
	// A helmet worn by an NPC must pass this random roll in order to be dropped
	q.m.HD_BaseDropChance <- 70;

	// Overwrite, because we implement the value of condition-based items in a more moddable way
	q.getValue = @() function()
	{
		local value = this.item.getValue() * this.HD_getConditionMult();
		return ::Math.floor(value);
	}

	// Overwrite, because we simplify the conditions and make them more moddable
	// Differences are:
	//	- We always return false, if we are in ScenarioMode
	//	- We add HD_MinConditionForPlayerDrop to make the condition for a guaranteed drop on a player, moddable
	//	- We add HD_MinConditionForDrop to make the minimum absolute condition required to drop this helmet moddable
	//	- We add HD_ConditionThresholdForDrop to make the the minimum relative condition required to drop this helmet moddable
	//	- We add HD_getDropChance() to make the random drop chance moddable and dynamic
	q.isDroppedAsLoot = @() function()
	{
		if (!this.item.isDroppedAsLoot()) return false;

		// To make this code easier to read, we return early, while in a Scenario. We assume that no scenario ever cares about looting helmets
		if (::Tactical.State.isScenarioMode()) return false;

		if (this.isItemType(::Const.Items.ItemType.Legendary)) return true;		// Legendary Gear always drops

		local isPlayer = this.m.LastEquippedByFaction == ::Const.Faction.Player || !::MSU.isNull(this.getContainer()) && ::MSU.isKindOf(this.getContainer().getActor(), "player");
		if (isPlayer)
		{
			if (this.getCondition() >= this.m.HD_MinConditionForPlayerDrop) return true;
			if (::World.Assets.m.IsBlacksmithed) return true;	// Blacksmith can prevent player gear from being destroyed
		}
		else
		{
			if (this.isItemType(::Const.Items.ItemType.Named)) return true;		// Named gear on enemies always drops
		}

		// Non-Player items skip the threshold checks and random rolls, if the scenario determines it so, just like for body armors
		if (!isPlayer && ::World.Assets.getOrigin().isDroppedAsLoot(this)) return true;

		// Check for the min condition value
		if (this.getCondition() < this.m.HD_MinConditionForDrop) return false;
		// Check for whether the condition threshold is met
		if ((this.getCondition() / (this.getConditionMax() * 1.0)) < this.m.HD_ConditionThresholdForDrop) return false;

		return ::Math.rand(1, 100) <= this.HD_getDropChance();
	}

// New Functions
	/// @return value between 0 and 100, which determines the likelyhood in %, that this item is dropped, if not guaranteed/forbidden by other conditions
	q.HD_getDropChance <- function()
	{
		return this.m.HD_BaseDropChance;
	}
});
