::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_spear", function(q) {
	// Private

	// Overwrite to remove the Spearwall Discount
	q.onAfterUpdate = @() function( _properties ) {}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsSpent = true;	// Disable the free spear attack each turn
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.getContainer().getActor().isDisarmed()) return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isItemType(::Const.Items.ItemType.MeleeWeapon) || !weapon.isWeaponType(::Const.Items.WeaponType.Spear)) return false;

		_properties.ReachAdvantageMult += (::Reforged.Reach.ReachAdvantageMult - 1.0);
	}

});
