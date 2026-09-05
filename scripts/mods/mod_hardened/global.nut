local experienceMult = ::Hardened.Const.ExperienceTierMult;
local resourceMult = ::Hardened.Const.ResourceTierMult;

{	// Variables
	::MSU.Table.merge(::Hardened.Global, {
	// Combat
		ActionPointChangeOnRally = -3,	// Whenever this actor rallies (going from fleeing to wavering) its action points change by this amount
		MinimumVision = 2,				// Vision of characters can never be reduced below this value. In Vanilla this is 1
		WeaponSpecFatigueMult = 0.8,	// Fatigue Multiplier for weapon skills, granted by all Weapon Masteries; Vanilla: 0.75

	// Character Screen
		SupportedBreakdowns = {
			"character-stats.ArmorHead": [
				{ Key = "Armor", Index = ::Const.BodyPart.Head, BaseIcon = "ui/icons/armor_head.png", Prefix = "Base: " },
				{ Key = "Armor", Index = ::Const.BodyPart.Head },
			],
			"character-stats.ArmorBody": [
				{ Key = "Armor", Index = ::Const.BodyPart.Body, BaseIcon = "ui/icons/armor_body.png", Prefix = "Base: " },
				{ Key = "Armor", Index = ::Const.BodyPart.Body },
			],
			"character-stats.Hitpoints": [
				{ Key = "Hitpoints", BaseIcon = "ui/icons/health.png", Prefix = "Base: " },
				{ Key = "Hitpoints" },
				{ Key = "HitpointsMult", IsMult = true },
			],
			"character-stats.ActionPoints": [
				{ Key = "ActionPoints", BaseIcon = "ui/icons/action_points.png", Prefix = "Base: " },
				{ Key = "ActionPoints" },
				{ Key = "ActionPointsMult", IsMult = true },
			],
			"character-stats.Fatigue": [
				{ Key = "Stamina", BaseIcon = "ui/icons/fatigue.png", Prefix = "Base: " },
				{ Key = "Stamina" },
				{ Key = "StaminaMult", IsMult = true },
				{ Key = "getStaminaModifierFromWeight", IsFunc = true, BaseIcon = "ui/icons/bag.png", IsActor = true, Prefix = "From Weight: " },
				{ Key = "getStaminaModifierFromWeight", IsFunc = true, IsActor = true},
				{ Key = "FatigueRecoveryRate", BaseIcon = "ui/icons/fatigue.png", Suffix = " Fatigue Recovery", Prefix = "Base: " },
				{ Key = "FatigueRecoveryRate", Suffix = " Fatigue Recovery" },
			],
			"Concept.Reach": [
				{ Key = "Reach", BaseIcon = "ui/icons/rf_reach.png", Prefix = "Base: " },
				{ Key = "Reach" },
				{ Key = "ReachMult", IsMult = true },
			],
			"character-stats.Bravery": [
				{ Key = "Bravery", BaseIcon = "ui/icons/bravery.png", Prefix = "Base: " },
				{ Key = "Bravery" },
				{ Key = "BraveryMult", IsMult = true },
			],
			"character-stats.Initiative": [
				{ Key = "Initiative", BaseIcon = "ui/icons/initiative.png", Prefix = "Base: " },
				{ Key = "Initiative" },
				{ Key = "InitiativeMult", IsMult = true },
				{ Key = "getInitiativeModifierFromWeight", IsFunc = true, BaseIcon = "ui/icons/bag.png", IsActor = true, Prefix = "From Weight: " },
				{ Key = "getInitiativeModifierFromWeight", IsFunc = true, IsActor = true },
				{ Key = "HD_getInitiativeModifierFromFatigue", IsFunc = true, BaseIcon = "ui/icons/initiative.png", IsActor = true, Prefix = "From Fatigue: " },
				{ Key = "HD_getInitiativeModifierFromFatigue", IsFunc = true, IsActor = true },
			],

			"character-stats.MeleeSkill": [
				{ Key = "MeleeSkill", BaseIcon = "ui/icons/melee_skill.png", Prefix = "Base: " },
				{ Key = "MeleeSkill" },
				{ Key = "MeleeSkillMult", IsMult = true },
			],
			"character-stats.RangeSkill": [
				{ Key = "RangedSkill", BaseIcon = "ui/icons/ranged_skill.png", Prefix = "Base: " },
				{ Key = "RangedSkill" },
				{ Key = "RangedSkillMult", IsMult = true },
			],
			"character-stats.MeleeDefense": [
				{ Key = "MeleeDefense", BaseIcon = "ui/icons/melee_defense.png", Prefix = "Base: " },
				{ Key = "MeleeDefense" },
				{ Key = "MeleeDefenseMult", IsMult = true },
			],
			"character-stats.RangeDefense": [
				{ Key = "RangedDefense", BaseIcon = "ui/icons/ranged_defense.png", Prefix = "Base: " },
				{ Key = "RangedDefense" },
				{ Key = "RangedDefenseMult", IsMult = true },
			],
			"character-stats.RegularDamage": [
				{ Key = "DamageTotalMult", IsMult = true },
			],
			"character-stats.CrushingDamage": [
				// This does not work well, because the base armor damage value is always 100% and weapons replace that value. This results in weird breakdowns coming from the weapon
				// { Key = "DamageArmorMult", BaseIcon = "ui/icons/armor_damage.png", IsPct = true },
			],
			"character-stats.ChanceToHitHead": [
				{ Key = "HitChance", BaseIcon = "ui/icons/chance_to_hit_head.png", Index = ::Const.BodyPart.Head, Prefix = "Base: ", Suffix = "%" },
				{ Key = "HitChance", Index = ::Const.BodyPart.Head, Suffix = "%" },
				{ Key = "HitChanceMult", Index = ::Const.BodyPart.Head, IsMult = true },
			],
			"character-stats.SightDistance": [
				{ Key = "Vision", BaseIcon = "ui/icons/vision.png", Prefix = "Base: " },
				{ Key = "Vision" },
				{ Key = "VisionMult", IsMult = true },
			],
		},

	// World
		LabelBackgroundAlpha = 150,		// Alpha value for the backgrounds of the world party and location labels

		ContractScalingBase = 1.0,		// This contract scaling is happening from day one. This scales multiplicatively with PerReputation scaling
		ContractScalingPerReputation = 0.0010,	// Each Reputation point causes contracts to be this much more lucrative and dangerous
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

	// Dynamic Spawns
		IdealSizeBase = 10.0,
		FieldableBrothersDefault = 10.0,
		FieldableBrothersPull = 0.5,
		BellCurveMult = [0.70, 1.30],
		CompressionMin = 6.0,
		CompressionMax = 24.0,
		CompressionPull = 0.5,
		FactionIdealSizeMult = {
			Barbarians = 1.0,
			Brigands = 1.0,
			CityStates = 1.2,
			Civilians = 1.2,
			Draugr = 1.0,
			Ghouls = 1.2,
			Goblins = 1.2,
			Hexen = 0.8,
			Lindwurms = 0.33,
			Mercenaries = 0.8,
			Militia = 1.2,
			Nobles = 1.2,
			Nomads = 1.0,
			Orcs = 0.8,
			Skeletons = 1.0,
			Schrats = 0.33,
			Slaves = 1.2,
			Spiders = 1.2,
			Unholds = 0.33,
			Vampires = 0.8,
			Zombies = 1.2,
		},
		PartySizeMult = {
			Location = 1.4,		// Locations have more quantity of units in general
			Caravan = 0.6,		// The main purpose of the units is transportation of themselves or some goods
			Scouts = 0.6,		// Fewer units, not meant to be a fighting force
			Offensive = 1.2,	// A special greater type of raiding party
			Specialists = 0.25,		// Specialists of one type, usually added on top of another party in a scripted combat
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
