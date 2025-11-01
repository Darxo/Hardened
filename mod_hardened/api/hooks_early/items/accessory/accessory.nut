::Hardened.HooksMod.hook("scripts/items/accessory/accessory", function(q) {
	// Private
	q.m.HD_BaseDropChance <- 100;	// An accessory worn by an NPC must pass this random roll in order to be dropped

	q.isDroppedAsLoot = @(__original) function()
	{
		if (!__original()) return false;

		local isPlayer = this.m.LastEquippedByFaction == ::Const.Faction.Player || this.getContainer() != null && this.getContainer().getActor() != null && !this.getContainer().getActor().isNull() && this.isKindOf(this.getContainer().getActor().get(), "player");
		if (isPlayer) return true;	// Accessories worn by player characters always drop

		// Random Chance-Based drop
		local isLucky = !::Tactical.State.isScenarioMode() && ::World.Assets.getOrigin().isDroppedAsLoot(this);
		if (isLucky) return true;	// If our scenario randomly decides it so, we will skip the chance based roll

		return ::Math.rand(1, 100) <= this.m.HD_BaseDropChance;
	}
});
