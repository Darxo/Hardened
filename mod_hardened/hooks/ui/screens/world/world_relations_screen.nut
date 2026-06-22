::Hardened.HooksMod.hook("scripts/ui/screens/world/world_relations_screen", function(q) {
	q.convertFactionsToUIData = @(__original) function()
	{
		local ret = __original();

		// Feat: we display placeholders in the faction & relation screen for every undiscovered faction
		foreach (faction in ::World.FactionManager.getFactions())
		{
			if (faction == null) continue;
			if (faction.getSettlements().len() == 0) continue;	// We only display factions here which have at least one faction associated
			if (faction.isHidden()) continue;		// Hidden factions are always hidden
			if (faction.isDiscovered()) continue;	// Already covered by __original

			ret.Factions.push({
				ID = faction.getID(),
				Name = "Unknown Faction",
				Description = "You have not discovered this faction yet",
				ImagePath = "",		// This causes "Unable to open file "gfx/". Error: Unknown mime type." to appear in the log once whenever the player opens the relation screen. An alternative would be to pass the deserter banner, but then its tooltip will spoil the undiscovered faction
				TypeImagePath = "ui/backgrounds/background_06.png",		// Unused
				Motto = "",
				Relation = "",
				RelationNum = 0,
				IsHostile = !faction.isAlliedWithPlayer(),
				Characters = [],
			});
		}

		return ret;
	}
});
