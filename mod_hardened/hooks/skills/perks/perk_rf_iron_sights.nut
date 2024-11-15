::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_iron_sights", function(q) {
	// Overwrite of Reforged: Iron Sights no longer requires a ranged weapon, so that it also works with the Firelance
	q.isEnabled = @() function()
	{
		if (this.getContainer().getActor().isDisarmed()) return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		return weapon != null && (weapon.isWeaponType(::Const.Items.WeaponType.Crossbow) || weapon.isWeaponType(::Const.Items.WeaponType.Firearm));
	}
});
