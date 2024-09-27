
::Hardened.HooksMod.hookTree("scripts/items/shields/shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ReachIgnore = 0;	// ReachIgnore is effectively removed from all shields
		this.m.Condition = this.m.ConditionMax;	// We do it here once instead of doing it by hand in every shield create function

		this.m.HardenedShieldConditionMax = this.m.ConditionMax;	// For named items this is wrong and already scaled
		if (this.isItemType(::Const.Items.ItemType.Named) && this.m.BaseItemScript != null)
		{
			local baseItem = ::new(this.m.BaseItemScript);
			this.m.HardenedShieldConditionMax = baseItem.m.ConditionMax;
			this.m.ReforgedShieldConditionMax = baseItem.m.ReforgedShieldConditionMax;

			this.m.ShieldConditionMult = 1.0 * this.m.ConditionMax / this.m.HardenedShieldConditionMax;
		}
	}

	// ::addItem("named_sipar_shield");

	q.onSerialize = @(__original) function(_out)
	{
		convertToReforged();
		__original(_out);
		convertToHardened();
	}

	q.onDeserialize = @(__original) function(_in)
	{
		convertToReforged();	// Shields are first created under the Hardened ruleset with vanilla values. So we need to convert them to Reforged numbers before we can load the reforged values

		__original(_in);
		if (this.isItemType(::Const.Items.ItemType.Named) && this.m.BaseItemScript != null)
		{
			local baseItem = ::new(this.m.BaseItemScript);

			if (this.m.ReforgedShieldConditionMax != null)
			{
				this.m.ShieldConditionMult = 1.0 * this.m.ConditionMax / this.m.ReforgedShieldConditionMax;
			}
		}

		convertToHardened();
	}
});
