::Hardened.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
	q.addBusinessReputation = @(__original) function( _f )
	{
		__original(_f);

		if (_f == 0) return;

		local activeScreen = null;
		if(::World.Contracts.getActiveContract() != null)
		{
			activeScreen = ::World.Contracts.getActiveContract().m.ActiveScreen;
		}
		else if(::World.Events.m.ActiveEvent != null)
		{
			activeScreen = ::World.Events.m.ActiveEvent.m.ActiveScreen;
		}

		if (activeScreen != null)
		{
			// We push a notification about the just gained renown into the current contract screen list, so the player has accurate information about it
			activeScreen.List.push({
				id = 30,
				icon = "ui/icons/ambition_tooltip.png",
				text = format("You %s %s Renown", _f > 0 ? "gain" : "lose", ::MSU.Text.colorizeValue(::Math.round(_f))),
			});
		}
	}

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
