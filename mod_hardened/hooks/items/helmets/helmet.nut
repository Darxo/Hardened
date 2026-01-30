::Hardened.HooksMod.hookTree("scripts/items/helmets/helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Condition = this.m.ConditionMax;		// We do this here so that it doesn't have to be done in the individual helmet scripts anymore

		// Hardened values
		this.m.HD_ConditionValueThreshold = 0.5;	// Condition now only scales the price of this down to 50% of its normal value
		this.m.HD_MinConditionForPlayerDrop = 1;	// Vanilla: 16
		this.m.HD_MinConditionForDrop = 0;			// Vanilla: 31
		this.m.HD_ConditionThresholdForDrop = 0.5;	// Vanilla: 0.25
		this.m.HD_BaseDropChance = 100;				// Vanilla: 70

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

	q.onDamageReceived = @(__original) function( _damage, _fatalityType, _attacker )
	{
		// We switcheroo the Name, adding the current condition to it, so that the combat log will include the condition of the armor piece before the hit
		local oldName = this.m.Name;
		this.m.Name += " (" + this.getCondition() + ")";

		// Vanilla Fix: Hide tooltips about armor taking damage, when its actor is not visible to the player
		local oldlogEx = ::Tactical.EventLog.get().logEx;
		if (this.getContainer().getActor().isHiddenToPlayer())
		{
			::Tactical.EventLog.get().logEx = function(_text) {};
		}

		__original(_damage, _fatalityType, _attacker);

		this.m.Name = oldName;
		::Tactical.EventLog.get().logEx = oldlogEx;
	}

// Hardened Functions
	q.getShopAmountMax = @() function()
	{
		// Almost never do you need to buy the third helmet of the same type. Buying the first two should be sufficient
		// By not generating the third this will prevent low tier and unneeded amounts of helmets from spamming late-game shops
		return 2;
	}

	// Overwrite, because we make the drop-chance of helmets relative to the relative remaining
	q.HD_getDropChance = @() function()
	{
		local pctCondition = this.getCondition() / (this.getConditionMax() * 1.0);

		// If we enter here, pctCondition is already guaranteed to be at least HD_ConditionThresholdForDrop and at most 1.0
		// Now we want to transform this range into one that ranges from 0.0 to 1.0
		// For that, we need to utilize HD_ConditionThresholdForDrop and normalize our pctCondition with its help
		local normalizedPctCondition = (pctCondition - this.m.HD_ConditionThresholdForDrop) * (1.0 / (1.0 - this.m.HD_ConditionThresholdForDrop));

		// The chance, that a body armor is looted, now drops linearly towards 0%, as its pctCondition moves towards HD_ConditionThresholdForDrop
		return this.m.HD_BaseDropChance * normalizedPctCondition;
	}
});
