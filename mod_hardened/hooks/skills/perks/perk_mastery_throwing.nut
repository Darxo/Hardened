::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_throwing", function(q) {
	// Public
	q.m.UnderhandThrowDamageMult <- 1.3;

	// Private
	q.m.IsQuickSwitchSpent <- false;		// Is quickswitching spent this turn?
	q.m.IsUnderhandThrowSpent <- false;		// Is first damaging attack spent this turn?

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (this.m.IsUnderhandThrowSpent) return;
		if (!this.isSkillValid(_skill)) return;

		_properties.DamageTotalMult	*= this.m.UnderhandThrowDamageMult;
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsQuickSwitchSpent = false;
		this.m.IsUnderhandThrowSpent = false;
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsQuickSwitchSpent = true;
		this.m.IsUnderhandThrowSpent = false;	// So that it shows up in your tooltip
	}

	q.onPayForItemAction = @(__original) function( _skill, _items )
	{
		__original(_skill, _items);
		if (_skill == this)
		{
			this.m.IsQuickSwitchSpent = true;
		}
	}

	// You can now swap a throwing weapon with an empty slot or an empty throwing weapon
	q.getItemActionCost = @(__original) function( _items )
	{
		__original(_items);

		if (this.m.IsQuickSwitchSpent) return null;

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

	// Overwrite: Mastery no longer applies onHit effects. This is now moved to hybridization
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.isSkillValid(_skill) && ::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			this.m.IsUnderhandThrowSpent = true;
		}
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		__original(_skill, _targetEntity);

		if (this.isSkillValid(_skill) && ::Tactical.TurnSequenceBar.isActiveEntity(this.getContainer().getActor()))
		{
			this.m.IsUnderhandThrowSpent = true;
			// Note, this will also be triggered just before the throwing attack goes astray and potentially still hits someone else.
			// That astrayed shot will then not profit from any damage.
			// However we can't differentiate such an astray shot for a legit miss at the moment, so this is "good enough"
		}
	}
});
