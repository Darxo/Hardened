::Hardened.HooksMod.hook("scripts/retinue/retinue_manager", function(q) {
	// Overwrite, because we make the itemslot amount, that you gain per upgrade, moddable
	q.upgradeInventory = @() function()
	{
		local newSize = ::World.Assets.getStash().getCapacity() + this.HD_getInventoryUpdateAmount();;
		::World.Assets.getStash().resize(newSize);

		++this.m.InventoryUpgrades;
	}

// New Functions
	q.HD_getInventoryUpdateAmount <- function()
	{
		local index = ::Math.min(this.getInventoryUpgrades(), ::Const.World.HD_InventoryUpgradeSlots.len());
		return ::Const.World.HD_InventoryUpgradeSlots[index];
	}
});
