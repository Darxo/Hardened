::Hardened.HooksMod.hookTree("scripts/items/helmets/helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Condition = this.m.ConditionMax;		// We do this here so that it doesn't have to be done in the individual helmet scripts anymore

		// We hook onPaint here, because it is not prevent on all helmets and we can't do the following check during regular hooking
		if ("onPaint" in this)
		{
			local oldOnPaint = this.onPaint;
			this.onPaint = function( _color )
			{
				oldOnPaint(_color);
				// We make sure this only happens for player as some mods might use onPaint to color enemies helmets
				if (this.isEquipped() && ::MSU.isKindOf(this.getContainer().getActor(), "player"))
				{
					::World.Statistics.getFlags().increment("PaintUsedOnHelmets");
				}
			}
		}
	}

	q.onAddedToStash = @(__original) function( _stashID )
	{
		__original(_stashID);

		if (_stashID == "player")
		{
			if (::Hardened.Mod.ModSettings.getSetting("AutoRepairNamedArmor").getValue())
			{
				if (this.isItemType(::Const.Items.ItemType.Named | ::Const.Items.ItemType.Legendary))
				{
					this.setToBeRepaired(true);
				}
			}
		}
	}

// Hardened Functions
	q.getShopAmountMax = @() function()
	{
		// Almost never do you need to buy the third helmet of the same type. Buying the first two should be sufficient
		// By not generating the third this will prevent low tier and unneeded amounts of helmets from spamming late-game shops
		return 2;
	}
});
