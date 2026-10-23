::Hardened.HooksMod.hook("scripts/skills/special/no_ammo_warning", function(q) {
	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		local requiredAmmoType = this.getContainer().getActor().getMainhandItem().HD_getAmmoType();
		if (requiredAmmoType != ::Const.Items.AmmoType.None)
		{
			ret.extend([
				{
					id = 20,
					type = "text",
					icon = "ui/icons/asset_ammo.png",
					text = "Requires: " + ::Hardened.Const.getAmmoType(requiredAmmoType).NamePlural,
				},
			]);
		}

		return ret;
	}}.getTooltip;

	// Overwrite, because we need to fix how vanilla connects ammo to ranged weapons and the most straightforward way is to overwrite this
	// We also fix how this function was needlessly flipping this.m.IsHidden
	q.isHidden = @() function()
	{
		local item = this.getContainer().getActor().getMainhandItem();
		if (item == null) return true;
		if (!item.isItemType(::Const.Items.ItemType.RangedWeapon)) return true;

		if (item.HD_canShoot()) return true;
		if (!::Tactical.isActive() && item.HD_hasEnoughAmmoForReload()) return true;	// Outside of combat we dont want to show the warning if the correct ammo is equipped

		return false;
	}
});
