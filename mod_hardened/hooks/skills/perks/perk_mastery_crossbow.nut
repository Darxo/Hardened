::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_crossbow", function(q) {
	q.m.RequiredWeaponType <- ::Const.Items.WeaponType.Crossbow | ::Const.Items.WeaponType.Firearm;

	// Overwrite, because we no longer grant an action point discount
	q.onAfterUpdate = @() function( _properties ) { }

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

	q.onEquip = @(__original) function( _item )
	{
		__original(_item);
		if (::Tactical.isActive() && ::Time.getRound() > 0)	// Round 0 is not interesting to us for this visibility calculation
		{
			// visibility is usually not changes when switching gear, but with crossbow mastery this can happen now. So we need to manually re-calculate visibility
			this.getContainer().getActor().updateVisibilityForFaction();
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
