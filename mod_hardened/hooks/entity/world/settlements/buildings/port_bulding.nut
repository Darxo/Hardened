
::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/port_building", function(q) {
	q.getUITravelRoster = @(__original) function()
	{
		local ret = __original();

		if (::Hardened.Mod.ModSettings.getSetting("DisplayForbiddenPorts").getValue())
		{
			foreach (settlement in ::World.EntityManager.getSettlements())
			{
				if (!settlement.isCoastal()) continue;	// This seems to be the universal vanilla check whether a town "has port access"
				if (settlement.getID() == this.m.Settlement.getID()) continue;
				if (this.isDestinationAllowed(settlement)) continue;	// These destinations are already covered by vanilla and added

				// Now we add all settlements, that are currently forbidden
				ret.Roster.push({
					ID = settlement.getID(),
					EntryID = ret.Roster.len(),
					ListName = "Sail to " + settlement.getName(),
					Name = settlement.getName(),
					Cost = this.getCostTo(settlement),
					ImagePath = settlement.getImagePath(),
					ListImagePath = settlement.getImagePath(),
					FactionImagePath = settlement.getOwner().getUIBannerSmall(),
					BackgroundText = settlement.getDescription() + "<br><br>" + this.getRandomDescription(settlement.getName()),
					IsDestinationAllowed = false,	// These destinations are listed, but greyed out
				});
			}
		}

		return ret;
	}

// New Functions
	q.isDestinationAllowed <- function( _destination )
	{
		return _destination.isAlliedWithPlayer() && this.m.Settlement.getOwner().isAlliedWith(_destination.getFaction());
	}
});
