::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_weapon_master", function(q) {
	// Public
	q.m.AdditionalBagSlots <- 1;

	// Overwrite, because we
	q.onEquip = @() function( _item )
	{
		if (!this.HD_isEnabledFor(_item)) return;

		this.HD_addPerksForPerkGroup(this.HD_getWeaponPerkGroupForItem(_item));
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.BagSlots += this.m.AdditionalBagSlots;
	}

// New Functions
	q.HD_isEnabledFor <- function( _item )
	{
		if (!_item.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (_item.isHybridWeapon()) return false;
		if (!this.HD_hasWeaponPerkGroupForItem(_item)) return false;

		return true;
	}

	q.HD_hasWeaponPerkGroupForItem <- function( _weapon )
	{
		local perkTree = this.getContainer().getActor().getPerkTree();
		foreach (weaponTypeName, weaponType in ::Const.Items.WeaponType)
		{
			if (!_weapon.isWeaponType(weaponType)) continue;

			if (weaponTypeName == "Firearm") weaponTypeName = "Crossbow";
			local perkGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_" + weaponTypeName.tolower());
			if (perkGroup == null) continue;	// No perk group exists for this weapon type

			if (perkTree.hasPerkGroup(perkGroup.getID())) return true;
		}

		return false;
	}

	q.HD_getWeaponPerkGroupForItem <- function( _weapon )
	{
		local perkTree = this.getContainer().getActor().getPerkTree();
		foreach (weaponTypeName, weaponType in ::Const.Items.WeaponType)
		{
			if (!_weapon.isWeaponType(weaponType)) continue;

			if (weaponTypeName == "Firearm") weaponTypeName = "Crossbow";
			return ::DynamicPerks.PerkGroups.findById("pg.rf_" + weaponTypeName.tolower());
		}

		return null;
	}

	q.HD_addPerksForPerkGroup <- function( _perkGroup )
	{
		foreach (row in _perkGroup.getTree())
		{
			foreach (perkID in row)
			{
				this.m.PerksAdded.push(perkID);
				this.getContainer().add(::Reforged.new(::Const.Perks.findById(perkID).Script, function(o) {
					o.m.IsSerialized = false;
					o.m.IsRefundable = false;
				}));
			}
		}
	}
});
