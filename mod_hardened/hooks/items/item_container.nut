::Hardened.HooksMod.hook("scripts/items/item_container", function(q) {
	// Private
	q.m.UseCachedActionCost <- false;
	q.m.CachedSwapActionCost <- null;	// We cache the last fetched action point cost in this variable instead of recalculating it when paying the action cost

	q.getActionCost = @(__original) function( _items )
	{
		if (this.m.UseCachedActionCost && this.m.CachedSwapActionCost != null)
		{
			return this.m.CachedSwapActionCost;
		}
		this.m.CachedSwapActionCost = __original(_items);

		{	// You can no longer swap your equipped ammo-item with an empty slot
			local isInAmmoSlot = false;
			local ammoItemCount = 0;
			foreach (item in _items)
			{
				if (item != null)
				{
					if (item.getCurrentSlotType() == ::Const.ItemSlot.Ammo)
						isInAmmoSlot = true;
					if (item.getSlotType() == ::Const.ItemSlot.Ammo)
						ammoItemCount++;
				}
			}

			if (isInAmmoSlot && ammoItemCount == 1)
			{
				this.m.CachedSwapActionCost = 99;
			}
		}

		return this.m.CachedSwapActionCost;
	}

	// MSU Fix: Use use cached value, instead of re-calculating, as now the items might have different slots or you lost skills on items that previously allows swapping
	q.payForAction = @(__original) function ( _items )
	{
		this.m.UseCachedActionCost = true;
		__original(_items);
		this.m.UseCachedActionCost = false;
		this.m.CachedSwapActionCost = null;
	}
});
