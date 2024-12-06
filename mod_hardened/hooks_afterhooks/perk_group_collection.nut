{	// Shared
	local sharedPgc = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_shared_1");
	sharedPgc.removePerkGroup("pg.rf_tactician");		// Tactician no longer competes with the other shared groups
	sharedPgc.m.Groups.push("pg.special.rf_leadership");	// Leadership now competes with the shared perks
	// ^ There is currently a bug in the perk group collection API. thats why I need to push it directly
}
