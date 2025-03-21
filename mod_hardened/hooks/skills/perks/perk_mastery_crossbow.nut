::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_crossbow", function(q) {
	q.m.RequiredWeaponType <- ::Const.Items.WeaponType.Crossbow | ::Const.Items.WeaponType.Firearm;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		if (this.isEnabled())
		{
			local helmet = this.getContainer().getActor().getItems().getItemAtSlot(::Const.ItemSlot.Head);
			if (helmet != null && helmet.m.Vision < 0)
			{
				_properties.Vision += 1;
			}
		}
	}

// New Reforged Functions
	q.isEnabled <- function()
	{
		if (this.m.RequiredWeaponType == null) return true;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isItemType(::Const.Items.ItemType.Weapon) || !weapon.isWeaponType(this.m.RequiredWeaponType))
		{
			return false;
		}

		return true;
	}
});
