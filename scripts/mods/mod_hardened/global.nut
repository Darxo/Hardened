{	// Variables
	::MSU.Table.merge(::Hardened.Global, {
	// World
		// This is a global resource multiplier for each Faction
		// Setting those to the same value would make each faction roughly equally strong
		FactionDifficulty = {
			Barbarians = 1.2,
			Beasts = 1.2,
			Brigands = 1.0,
			Caravans = 0.8,
			CityState = 1.4,
			Civilians = 0.6,
			Goblins = 1.2,
			Hexen = 1.4,
			Mercenaries = 1.2,
			Militia = 0.8,
			Nobles = 1.4,
			Nomads = 1.0,
			Orcs = 1.4,
			Skeletons = 1.2,
			Slaves = 0.6,
			Vampires = 1.4,
			Zombies = 1.0,
		},
	});
}
