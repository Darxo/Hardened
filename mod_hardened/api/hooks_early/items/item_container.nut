::Hardened.HooksMod.hook("scripts/items/item_container", function(q) {
	// Overwrite, because we need to fix how vanilla connects ammo to ranged weapons and the most straightforward way is to overwrite this
	// Determine whether this item container contains any "defensive" item, as in those with the Defensive type and which are usable (loaded)
	q.hasDefensiveItem = @() function()
	{
		local items = this.getAllItems();

		foreach (item in items)
		{
			if (!item.isItemType(::Const.Items.ItemType.Defensive)) continue;
			if (!item.isItemType(::Const.Items.ItemType.Weapon)) return true;	//

			if (item.getAmmoMax() == 0 || item.getAmmo() > 0) return true;	// The weapon does not use ammo or has enough ammo to function

			foreach (ammo in items)
			{
				if (ammo.getAmmoType() == item.HD_getAmmoType() && ammo.getAmmo() > 0) return true;	// getAmmo > 0 is just an abstraction. Some weapons might need more than 1 ammo to reload
			}
		}

		return false;
	}
});
