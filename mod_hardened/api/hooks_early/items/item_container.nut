::Hardened.HooksMod.hook("scripts/items/item_container", function(q) {
	// Overwrite, because we need to fix how vanilla connects ammo to ranged weapons and the most straightforward way is to overwrite this
	// Determine whether this item container contains any "defensive" item, as in those with the Defensive type and which are usable (loaded)
	q.hasDefensiveItem = @() function()
	{
		local items = this.getAllItems();

		foreach (item in items)
		{
			if (!item.isItemType(::Const.Items.ItemType.Defensive)) continue;
			if (!item.isItemType(::Const.Items.ItemType.Weapon)) return true;	// Non-Weapon defensive items work out of the box
			if (!item.isItemType(::Const.Items.ItemType.RangedWeapon)) return true;	// Non-Ranged weapons always work ouf of the box

			if (item.HD_canShoot()) return true;	// The weapon has enough ammo to function
			foreach (ammo in items)
			{
				if (ammo.isItemType(::Const.Items.ItemType.Ammo) && ammo.getAmmoType() == item.HD_getAmmoType() && ammo.getAmmo() > 0) return true;	// getAmmo > 0 is just an abstraction. Some weapons might need more than 1 ammo to reload
			}
		}

		return false;
	}
});
