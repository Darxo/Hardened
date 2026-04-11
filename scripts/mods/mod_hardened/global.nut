local experienceMult = ::Hardened.Const.ExperienceTierMult;
local resourceMult = ::Hardened.Const.ResourceTierMult;

{	// Variables
	::MSU.Table.merge(::Hardened.Global, {
	// Combat
		ActionPointChangeOnRally = -3,	// Whenever this actor rallies (going from fleeing to wavering) its action points change by this amount
		MinimumVision = 2,				// Vision of characters can never be reduced below this value. In Vanilla this is 1
		WeaponSpecFatigueMult = 0.8,	// Fatigue Multiplier for weapon skills, granted by all Weapon Masteries; Vanilla: 0.75

	// World
		LabelBackgroundAlpha = 150,		// Alpha value for the backgrounds of the world party and location labels

		ContractScalingBase = 1.0,		// This contract scaling is happening from day one. This scales multiplicatively with PerReputation scaling
		ContractScalingPerReputation = 0.0008,	// Each Reputation point causes contracts to be this much more lucrative and dangerous
		ContractScalingMin = 0.5,		// Contracts never scale below this value
		ContractScalingMax = 10.0,		// Contracts never scale beyond this value
		WorldScalingBase = 1.0,			// This world scaling is happening from day one. This scales multiplicatively with PerDay scaling
		WorldScalingMin = 0.5,			// The world will never scale below this value
		WorldScalingMax = 5.0,			// The world will never scale beyond this value
		WorldScalingPerDay = 0.013,		// Each passed day causes the world to be this much more dangerous

		ContractNegotiationRelationCost = -1.0,	// Relation with town takes this much of a hit each time you try to negotiate (Vanilla: -0.5)
		ContractNegotiationPaymentMult = [1.1, 1.3],	// Minimum and Maximum Payment Multiplier for succesful negotiations; (Vanilla: 3%-10%)

		// This is a global resource multiplier for each Faction
		// Setting those to the same value would make each faction roughly equally strong
		FactionDifficulty = {
			Barbarians = resourceMult.Tier2,
			Beasts = resourceMult.Tier2,
			Brigands = resourceMult.Tier3,
			Caravans = resourceMult.Tier4,
			CityState = resourceMult.Tier1,
			Civilians = resourceMult.Tier5,
			Draugr = resourceMult.Tier1,
			Goblins = resourceMult.Tier2,
			Hexen = resourceMult.Tier1,
			Mercenaries = resourceMult.Tier2,
			Militia = resourceMult.Tier4,
			Nobles = resourceMult.Tier1,
			Nomads = resourceMult.Tier3,
			Orcs = resourceMult.Tier1,
			Skeletons = resourceMult.Tier2,
			Slaves = resourceMult.Tier5,
			Vampires = resourceMult.Tier1,
			Zombies = resourceMult.Tier3,
		},

		// This is a global xp multiplier for each Faction
		// Setting those to the same value would make each faction roughly equally rewarding in terms of XP
		FactionExperience = {
			Barbarians = experienceMult.Tier4,
			Beasts = experienceMult.Tier4,
			Brigands = experienceMult.Tier2,
			Caravans = experienceMult.Tier2,
			CityStates = experienceMult.Tier3,
			Civilians = experienceMult.Tier1,
			Draugr = experienceMult.Tier5,
			Goblins = experienceMult.Tier4,
			Hexen = experienceMult.Tier4,
			Mercenaries = experienceMult.Tier3,
			Militia = experienceMult.Tier2,
			Nobles = experienceMult.Tier3,
			Nomads = experienceMult.Tier2,
			Orcs = experienceMult.Tier5,
			Skeletons = experienceMult.Tier4,
			Slaves = experienceMult.Tier1,
			Vampires = experienceMult.Tier4,
			Zombies = experienceMult.Tier5,
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

		// Add a new Entity Entry that can be used to split different entities on the world map to use unique names and icons
		// _entityID string that is the new and unique internal ID for this entity
		// _name display name for when a single of this unit is present
		// _namePlural display name for when multiple of this unit is present in a world party
		// _orientationIcon icon that is displayed in world map tooltips
		// _defaultFaction the default faction that is assigned to this unit when spawned in battle
		// _relatedScript is the script for which this new entry is supposed to be a replacement
		// _fallBackEntityID the entity ID, that this troop in a world party will receive during deserialization to stay compatible with Reforged
		addTemporaryEntity = function( _entityID, _name, _namePlural, _orientationIcon, _defaultFaction, _relatedScript, _fallBackEntityID )
		{
			local highestID = 0;
			foreach (key, value in ::Const.EntityType)
			{
				if (typeof value == "integer" && value > highestID)
					highestID = value;
			}
			++highestID;

			::Const.EntityType[_entityID] <- highestID;
			::Const.Strings.EntityName.push(_name);
			::Const.Strings.EntityNamePlural.push(_namePlural);
			::Const.EntityIcon.push(_orientationIcon);
			::Reforged.Entities.DefaultFaction[highestID] <- _defaultFaction;

			::Hardened.Global.addEntityFallback(_relatedScript, _fallBackEntityID, highestID);
		}

		addEntityFallback = function( _scriptName, _reforgedID, _hardenedID )
		{
			::Hardened.Private.EntityIDFallback[_scriptName] <- {
				Reforged = _reforgedID,
				Hardened = _hardenedID,
			}

			foreach (key, troop in ::Const.World.Spawn.Troops)
			{
				if (troop.Script == _scriptName)
				{
					troop.ID = _hardenedID;
				}
			}
		}

		hasEntityFallbackID = function( _scriptName )
		{
			return _scriptName in ::Hardened.Private.EntityIDFallback;
		}

		getEntityFallbackID = function( _scriptName )
		{
			return ::Hardened.Private.EntityIDFallback[_scriptName];
		}

		switchWorldTroopsToReforged = function( _worldParty )
		{
			foreach (troop in _worldParty.m.Troops)
			{
				if (::Hardened.Global.hasEntityFallbackID(troop.Script))
				{
					// During serialization, we replace all entity IDs, which only temporarily exist within Hardened,
					// so that the saves can be loaded correctly with just Base Reforged
					troop.ID = ::Hardened.Global.getEntityFallbackID(troop.Script).Reforged;
				}
			}
		}

		switchWorldTroopsToHardened = function( _worldParty )
		{
			foreach (troop in _worldParty.m.Troops)
			{
				if (::Hardened.Global.hasEntityFallbackID(troop.Script))
				{
					// During deserialization, we replace all entity IDs, for which there are new, Hardened-only variants
					troop.ID = ::Hardened.Global.getEntityFallbackID(troop.Script).Hardened;
				}
			}
		}
	});
}
