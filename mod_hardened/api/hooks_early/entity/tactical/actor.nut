::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Overwrite, because we need to fix how vanilla connects ammo to ranged weapons and the most straightforward way is to overwrite this
	// This function gathers information about the state of this characters equipped ranged weapons, most notably what range they are operating on
	q.getRangedWeaponInfo = @() function()
	{
		local items = [];

		local mainhand = this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhand != null) items.push(mainhand);

		local bags = this.m.Items.getAllItemsAtSlot(::Const.ItemSlot.Bag);
		if (bags.len() != 0) items.extend(bags);

		local result = {
			HasRangedWeapon = false,
			IsTrueRangedWeapon = false,
			Range = 0,
			RangeWithLevel = 0,
		};

		if (items.len() == 0) return result;

		foreach (it in items)
		{
			if (!it.isItemType(::Const.Items.ItemType.RangedWeapon)) continue;
			if (!it.HD_canShoot()) continue;	// Todo: Vanilla also checks for the ammo in bags, but we skip that step. That's something for another day

			result.HasRangedWeapon = true;
			if (this.isTrueRanged(it)) result.IsTrueRangedWeapon = true;

			local range = ::Math.min(it.getRangeEffective() + it.getAdditionalRange(this), this.getCurrentProperties().getVision());
			result.Range = ::Math.max(result.Range, range);
			result.RangeWithLevel = ::Math.max(result.RangeWithLevel, range + ::Math.min(it.getRangeMaxBonus(), this.getTile().Level));
		}

		return result;
	}

	// Overwrite, because we need to fix how vanilla connects ammo to ranged weapons and the most straightforward way is to overwrite this
	q.hasRangedWeapon = @() function( _trueRangedOnly = false )
	{
		local items = [];

		local mainhand = this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand);
		if (mainhand != null) items.push(mainhand);

		local bags = this.m.Items.getAllItemsAtSlot(::Const.ItemSlot.Bag);
		if (bags.len() != 0) items.extend(bags);

		if (items.len() == 0) return false;

		foreach (it in items)
		{
			if (!it.isItemType(::Const.Items.ItemType.RangedWeapon)) continue;
			if (_trueRangedOnly && !this.isTrueRanged(it)) continue;
			if (it.HD_canShoot()) return true;
		}

		return false;
	}

// New Functions
	// Helper function to determine, whether this actor is considered a "true ranged unit"
	q.isTrueRanged <- function( _item )
	{
		if (this.getCurrentProperties().getRangedSkill() < 45) return false;
		if (::Math.min(_item.getRangeMax(), this.getCurrentProperties().getVision()) < 6) return false;

		return true;
	}
});
