::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_weapon_master", function(q) {
	// Public
	q.m.AdditionalBagSlots <- 1;

	q.onEquip = @(__original) function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isHybridWeapon())
		{
			return;		// Hybrid weapons no longer work with Weapon Master
		}

		// Reforged Fix: Reforged always adds the perks of the weapon, even if not available in the tree. We filter those cases out early
		if (_item.isItemType(::Const.Items.ItemType.Weapon))
		{
			local perkTree = this.getContainer().getActor().getPerkTree();
			foreach (weaponTypeName, weaponType in ::Const.Items.WeaponType)
			{
				if (!_item.isWeaponType(weaponType)) continue;

				if (weaponTypeName == "Firearm") weaponTypeName = "Crossbow";
				if (!perkTree.hasPerkGroup("pg.rf_" + weaponTypeName.tolower()))
				{
					return;		// Reforged Fix: Our perk tree does not contain the weapon group for _item, so we return early
				}
			}
		}

		return __original(_item);
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.BagSlots += this.m.AdditionalBagSlots;
	}
});
