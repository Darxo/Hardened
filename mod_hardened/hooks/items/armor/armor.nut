::Hardened.HooksMod.hookTree("scripts/items/armor/armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Condition = this.m.ConditionMax;		// We do this here so that it doesn't have to be done in the individual armor scripts anymore
	}

	q.onAddedToStash = @(__original) function( _stashID )
	{
		__original(_stashID);

		if (_stashID == "player")
		{
			if (::Hardened.Mod.ModSettings.getSetting("AutoRepairUpgradedArmor").getValue())
			{
				if (this.getUpgrade() != null)
				{
					this.setToBeRepaired(true);
				}
			}

			if (::Hardened.Mod.ModSettings.getSetting("AutoRepairNamedArmor").getValue())
			{
				if (this.isItemType(::Const.Items.ItemType.Named | ::Const.Items.ItemType.Legendary))
				{
					this.setToBeRepaired(true);
				}
			}
		}
	}
});
