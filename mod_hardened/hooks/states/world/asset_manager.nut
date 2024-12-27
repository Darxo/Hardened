::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.checkDesertion = @(__original) function()
	{
		__original();
		if (!::World.Events.canFireEvent()) return;

		local event = ::World.Events.getEvent("event.retinue_slot");
		local unlockedSlots = ::World.Retinue.getNumberOfUnlockedSlots();
		if (unlockedSlots > event.m.LastSlotsUnlocked && ::World.Retinue.getNumberOfCurrentFollowers() < unlockedSlots)
		{
			::World.Events.fire("event.retinue_slot", false);
		}
	}

	q.getMoralReputationAsText = @(__original) function()
	{
		local ret = __original();

		if (::Hardened.Mod.ModSettings.getSetting("DisplayMoraleValue").getValue())
		{
			ret += " (" + this.m.MoralReputation + ")";
		}

		return ret;
	}

	q.getBusinessReputationAsText = @(__original) function()
	{
		local ret = __original();

		if (::Hardened.Mod.ModSettings.getSetting("AlwaysDisplayRenownValue").getValue())
		{
			ret += " (" + this.m.BusinessReputation + ")";
		}

		return ret;
	}
});
