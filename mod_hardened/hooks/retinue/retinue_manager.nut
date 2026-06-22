::Hardened.HooksMod.hook("scripts/retinue/retinue_manager", function(q) {
	// Overwrite, because we make the itemslot amount, that you gain per upgrade, moddable
	q.upgradeInventory = @() function()
	{
		local newSize = ::World.Assets.getStash().getCapacity() + this.HD_getInventoryUpdateAmount();
		::World.Assets.getStash().resize(newSize);

		++this.m.InventoryUpgrades;
	}

	q.getCurrentFollowersForUI = @(__original) function()
	{
		local ret = __original();

		// Feat: We allow opening the retinue hiring screen, even if no slots are unlocked yet
		if (this.getNumberOfUnlockedSlots() == 0)
		{
			foreach (entry in ret)
			{
				// We can write anything in here, other than "locked" to make js allow these buttons to be clicked
				// In order to later generate a correct tooltip depending the slot, we need to put the slot number in here too
				entry.ID = "locked;" + entry.Slot;
			}
		}

		return ret;
	}

	q.getFollowersForUI = @(__original) function()
	{
		local ret = __original();

		// Since we allow the retinue hiring screen to be opened even with 0 slots unlocked, we must now artificially lock every available member
		if (this.getNumberOfUnlockedSlots() == 0)
		{
			foreach (entry in ret)
			{
				entry.IsUnlocked = false;

				// Vanilla pushes a reference to the retinue requirements in here.
				// We must turn that reference into a full clone; otherwise we permanently add our dummy requirement there
				entry.Requirements = ::MSU.deepClone(entry.Requirements);
				entry.Requirements.push({
					IsSatisfied = false,
					Text = "No available retinue slot",
				})
			}
		}

		return ret;
	}

// New Functions
	q.HD_getInventoryUpdateAmount <- function()
	{
		local index = ::Math.min(this.getInventoryUpgrades(), ::Const.World.HD_InventoryUpgradeSlots.len());
		return ::Const.World.HD_InventoryUpgradeSlots[index];
	}
});
