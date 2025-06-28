// The reforged hook for this perk is being sniped
::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_spear", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.getContainer().getActor().isDisarmed()) return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isItemType(::Const.Items.ItemType.MeleeWeapon) || !weapon.isWeaponType(::Const.Items.WeaponType.Spear)) return false;

		_properties.ReachAdvantageMult += (::Reforged.Reach.ReachAdvantageMult - 1.0);
	}
});
