::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_opportunist", function(q) {
	// Reforged Functions
		// Overwrite because we can't remove that individual condition that easy
		q.isEnabled = @() function()
		{
			if (this.getContainer().getActor().isDisarmed()) return false;

			local weapon = this.getContainer().getActor().getMainhandItem();
			if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Throwing))	// Only difference is here: the removal of the getAmmoMax check
			{
				return false;
			}

			return true;
		}
});
