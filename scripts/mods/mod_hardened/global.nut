{	// Variables
	::MSU.Table.merge(::Hardened.Global, {
	// Tactical
		ActionPointChangeOnRally = -3,	// Whenever this actor rallies (going from fleeing to wavering) its action points change by this amount
		MinimumVision = 2,				// Vision of characters can never be reduced below this value. In Vanilla this is 1

	// World
		ContractScalingBase = 1.0,		// This contract scaling is happening from day one. This scales multiplicatively with PerReputation scaling
		ContractScalingPerReputation = 0.0007,	// Each Reputation point causes contracts to be this much more lucrative and dangerous
		ContractScalingMin = 0.5,		// Contracts never scale below this value
		ContractScalingMax = 10.0,		// Contracts never scale beyond this value
		WorldScalingBase = 1.0,			// This world scaling is happening from day one. This scales multiplicatively with PerDay scaling
		WorldScalingMin = 0.5,			// The world will never scale below this value
		WorldScalingMax = 5.0,			// The world will never scale beyond this value
		WorldScalingPerDay = 0.013,		// Each passed day causes the world to be this much more dangerous

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

{	// Functions

	::MSU.Table.merge(::Hardened.Global, {
		// Anything that uses spawntables to spawn/add troops, will have its available resources adjusted by this value
		getWorldDifficultyMult = function() {
			local ret = ::Hardened.Global.WorldScalingBase * (1.0 + ::World.getTime().Days * ::Hardened.Global.WorldScalingPerDay);
			return ::Math.clampf(ret, ::Hardened.Global.WorldScalingMin, ::Hardened.Global.WorldScalingMax);
		},

		// All contracts will be this much harder and also yield this much more rewards
		getWorldContractMult = function() {
			local ret = ::Hardened.Global.ContractScalingBase * (1.0 + ::World.Assets.getBusinessReputation() * ::Hardened.Global.ContractScalingPerReputation);
			return ::Math.clampf(ret, ::Hardened.Global.ContractScalingMin, ::Hardened.Global.ContractScalingMax);
		},
	});
}
