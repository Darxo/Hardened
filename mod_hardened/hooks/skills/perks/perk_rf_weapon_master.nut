::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_weapon_master", function(q) {
	// Public
	q.m.AdditionalBagSlots <- 1;

	q.onEquip = @(__original) function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isHybridWeapon())
		{
			return;		// Hybrid weapons no longer work with Weapon Master
		}

		return __original(_item);
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.BagSlots += this.m.AdditionalBagSlots;
	}
});
