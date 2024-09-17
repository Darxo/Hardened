::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_dagger", function(q) {
	// Private
	q.m.IsQuickSwitchSpent <- false;		// Is quickswitching spent this turn?

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsQuickSwitchSpent = false;
	}

	q.onPayForItemAction = @(__original) function( _skill, _items )
	{
		__original(_skill, _items);
		if (_skill == this)
		{
			this.m.IsQuickSwitchSpent = true;
		}
	}

	// Swapping items becomes a free action once per turn if one of them is a dagger
	q.getItemActionCost = @(__original) function( _items )
	{
		__original(_items);

		if (this.m.IsQuickSwitchSpent) return null;
		if (!this.isEnabled()) return null;

		return 0;
	}

// New Functions
	q.isEnabled <- function()
	{
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
		{
			return false;
		}

		return true;
	}
});
