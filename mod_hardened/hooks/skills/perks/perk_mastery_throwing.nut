::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_throwing", function(q) {
	// Private
	q.m.IsSpent <- false;	// Is quickswitching spent this turn?

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsSpent = false;	// IsSpent now stays always stays on true to disable swapping and hide the effect icon
	}

	q.onPayForItemAction = @(__original) function( _skill, _items )
	{
		__original(_skill, _items);
		if (_skill == this)
		{
			this.m.IsSpent = true;
		}
	}

	// You can now swap a throwing weapon with an empty slot or an empty throwing weapon
	q.getItemActionCost = @(__original) function( _items )
	{
		__original(_items);

		if (this.m.IsSpent) return null;

		local sourceItem = _items[0];
		local targetItem = _items.len() > 1 ? _items[1] : null;

		if (sourceItem == null)		// Fix for when other mods break convention and instead have the first item in the array be the destination item (e.g. Extra Keybinds)
		{
			sourceItem = targetItem;
			targetItem = null;
		}

		if (sourceItem.isItemType(::Const.Items.ItemType.Weapon) && sourceItem.isWeaponType(::Const.Items.WeaponType.Throwing))
		{
			if (targetItem == null)	// Either the target is an empty slot
			{
				return 0;
			}

			if (targetItem.isItemType(::Const.Items.ItemType.Weapon) && targetItem.isWeaponType(::Const.Items.WeaponType.Throwing))
			{
				if ((sourceItem.m.Ammo == 0 && sourceItem.m.AmmoMax != 0) || (targetItem.m.Ammo == 0 && targetItem.m.AmmoMax != 0))	// Or either of the two throwing weapons uses ammunition and is empty
				{
					return 0;
				}
			}
		}

		return null;
	}

	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		// Do nothing. Mastery no longer applies onHit effects. This is now moved to hybridization
	}
});
