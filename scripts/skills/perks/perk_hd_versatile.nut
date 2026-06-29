this.perk_hd_versatile <- ::inherit("scripts/skills/skill", {
	m = {
		// Public

		// Private
		AddedWeaponTypes = {},	// Key is the weapontype and Value is a bool, whether the currently equipped weapon was given this additional type
	},
	function create()
	{
		this.m.ID = "perk.hd_versatile";
		this.m.Name = ::Const.Strings.PerkName.HD_Versatile;
		this.m.Icon = "ui/perks/perk_rf_swordmaster_versatile_swordsman.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.First;	// We need to be first, because our added itemtypes decide, which other perk triggers its effect during onEquip

		foreach (key, value in ::Const.Items.WeaponType)
		{
			if (key == "None") continue;
			this.m.AddedWeaponTypes[value] <- false;
		}
	}

	function onAdded()
	{
		// We refresh our mainhand item to generate weapon types for it and add skills coming from other perks/effects correctly
		this.HD_refreshMainhandItem();
	}

	function onEquip( _item )
	{
		if (!this.isEnabled()) return;
		if (_item.getSlotType() != ::Const.ItemSlot.Mainhand) return;

		this.HD_addWeaponTypes(_item);
	}

	function onUnequip( _item )
	{
		if (!this.isEnabled()) return;
		if (_item.getSlotType() != ::Const.ItemSlot.Mainhand) return;

		this.HD_removeWeaponTypes(_item);
	}

	function onRemoved()
	{
		// We refresh mainhand item to restore any original weapon types on it
		this.HD_refreshMainhandItem();
	}

// New Functions
	function isEnabled()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null) return false;
		if (!weapon.isWeaponType(::Const.Items.WeaponType.Sword)) return false;

		return true;
	}

	function HD_refreshMainhandItem()
	{
		local actor = this.getContainer().getActor();
		local mainhandItem = this.getContainer().getActor().getMainhandItem();
		if (mainhandItem != null)
		{
			actor.getItems().unequip(mainhandItem);
			actor.getItems().equip(mainhandItem);
		}
	}

	// Add all weapon types from this.m.AddedWeaponTypes to _item, which it doesn't already have, and mark those types with "true"
	function HD_addWeaponTypes( _item )
	{
		foreach (weaponType, wasAdded in this.m.AddedWeaponTypes)
		{
			if (_item.isWeaponType(weaponType))
			{
				this.m.AddedWeaponTypes[weaponType] = false;
			}
			else
			{
				this.m.AddedWeaponTypes[weaponType] = true;
				_item.addWeaponType(weaponType, true);
			}
		}
	}

	// Remove all weapon type from _item, which were marked as true in this.m.AddedWeaponTypes
	function HD_removeWeaponTypes( _item )
	{
		foreach (weaponType, wasAdded in this.m.AddedWeaponTypes)
		{
			if (!wasAdded) continue;

			_item.removeWeaponType(weaponType, true);
			this.m.AddedWeaponTypes[weaponType] = false;
		}
	}
});
