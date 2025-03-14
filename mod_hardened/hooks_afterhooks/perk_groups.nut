/*
Regular hooking of Perk Groups does not work because they are instantiated before any hooks run
They are pushed into ::DynamicPerks.PerkGroups during the execution of scripts/mods/mod_reforged/load.nut
THerefor the only way we can "hook"" them is by fetching and changing the instantiated objects from the Lookup Maps
Same is true for perk_group_collections (::DynamicPerks.PerkGroupCategories)
*/

// Helper function to change the perk tier of a _perkID from _perkGroup to tier _newTier
local changePerkTier = function( _perkGroup, _perkID, _newTier )
{
	if (_perkGroup.hasPerk(_perkID))
	{
		_perkGroup.removePerk(_perkID);
		_perkGroup.addPerk(_perkID, _newTier);
	}
}

// Adjust Reforged Perk Groups
{
	{	// Always Group
		local pgAlwaysGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_always_1");
		pgAlwaysGroup.addPerk("perk.student", 1);	// Add Student
		pgAlwaysGroup.removePerk("perk.bags_and_belts");
		pgAlwaysGroup.m.Icon = "ui/perks/perk_21.png";		// In Reforged this uses the icon of Bags and Belts
	}

	{	// Agile Group
		local pgAgileGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_agile");
		pgAgileGroup.removePerk("perk.rf_death_dealer");
		pgAgileGroup.addPerk("perk.rf_dynamic_duo", 4);			// Replace "Death Dealer" with "Dynamic Duo"
		changePerkTier(pgAgileGroup, "perk.footwork", 1);		// Move Footwork to Tier 1 (up from Tier 5)
		changePerkTier(pgAgileGroup, "perk.pathfinder", 3);		// Move Pathfinder to Tier 3 (up from Tier 1)
	}

	{	// Axe Group
		local pgAxeGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_axe");
		changePerkTier(pgAxeGroup, "perk.rf_dismemberment", 2);		// Move Dismemberment to Tier 2 (up from Tier 6)
		changePerkTier(pgAxeGroup, "perk.rf_dismantle", 6);			// Move Dismantle to Tier 6 (up from Tier 2)
	}

	{	// Fast Group
		local pgFastGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_fast");
		pgFastGroup.removePerk("perk.rf_dynamic_duo");					// Remove Dynamic Duo from Fast group as it moved to agile group
		pgFastGroup.addPerk("perk.rf_wear_them_down", 3);				// Add Wear them Down to Tier 3
		changePerkTier(pgFastGroup, "perk.rf_combo", 5);				// Move Combo to Tier 5 (down from Tier 7)
		changePerkTier(pgFastGroup, "perk.rf_calculated_strikes", 7);	// Calculated Strikes to Tier 7 (up from Tier 5)
	}

	{	// Hammer Group
		local pgHammerGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_hammer");
		changePerkTier(pgHammerGroup, "perk.rf_rattle", 6);			// Move rattle (Full Force) into the position where Deep Impact was previously
		changePerkTier(pgHammerGroup, "perk.rf_deep_impact", 3);	// Move Deep Impact into the position where Rattle (Full Force) was previously
	}

	{	// Knave Group
		local pgKnaveGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_knave");
		changePerkTier(pgKnaveGroup, "perk.rf_cheap_trick", 1);			// Move "Cheap Trick" to Tier 1 (down from Tier 2)
		changePerkTier(pgKnaveGroup, "perk.rf_tricksters_purses", 3);		// Move "Tricksters Purses" to Tier 3 (up from Tier 1)
		changePerkTier(pgKnaveGroup, "perk.rf_ghostlike", 5);				// Move "Ghostlike" to Tier 5 (up from Tier 4)
		pgKnaveGroup.getPerkGroupMultiplier = function( _groupID, _perkTree )
		{
			switch (_groupID)
			{
				case "pg.rf_dagger":
					return 2.0;		// In Reforged this is -1
				case "pg.rf_light_armor":
					return -1.0;	// In Reforged this is -1
			}
		}
	}

	{	// Laborer Group
		local pgLaborerGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_laborer");
		pgLaborerGroup.removePerk("perk.bags_and_belts");	// Remove Bags and Belts
	}

	{	// Light Armor Group
		local pgLightArmorGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_light_armor");
		pgLightArmorGroup.addPerk("perk.bags_and_belts", 1);	// Add Bags and Belts
		pgLightArmorGroup.removePerk("perk.dodge");					// Remove Dodge
	}

	{	// Leadership Group
		::DynamicPerks.PerkGroups.remove("pg.special.rf_leadership");
		::DynamicPerks.PerkGroups.add(::new("scripts/mods/mod_hardened/perk_groups/pg_hd_leadership"));		// We introduce our own non-special Leadership Group
	}

	{	// Mace Group
		local pgMaceGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_mace");
		changePerkTier(pgMaceGroup, "perk.rf_bone_breaker", 5);			// Move Bone Breaker from Tier 7 down to Tier 5
	}

	{	// Net Group
		local pgNetGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_trapper");
		changePerkTier(pgNetGroup, "perk.rf_angler", 2);			// Move Angler from Tier 3 down to Tier 2
	}

	{	// Noble Group
		local pgNobleGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_noble");
		pgNobleGroup.addPerk("perk.inspiring_presence", 7);		// Add Inspiring Presence to Tier 7
	}

	{	// Polearm Combat
		local pgPolearmGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_polearm");
		changePerkTier(pgPolearmGroup, "perk.rf_long_reach", 3);	// Move "Long Reach" to Tier 3 (down from Tier 7)
		changePerkTier(pgPolearmGroup, "perk.rf_leverage", 6);		// Move "Leverage" to Tier 6 (up from Tier 3)
	}

	{	// Power Combat
		local pgPowerGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_power");
		pgPowerGroup.addPerk("perk.rf_death_dealer", 6);	// Add Death Dealer to Tier 6
	}

	{	// Ranged Combat
		local pgRangedGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_ranged");
		pgRangedGroup.removePerk("perk.overwhelm");		// Remove Overwhelm from Ranged
		changePerkTier(pgRangedGroup, "perk.bullseye", 6);		// Move "Bullseye" to Tier 6 (up from Tier 3)

		pgRangedGroup.addPerk("perk.hd_scout", 1);	// Add Scout (New Hardened Perk) into the Tier 1
		pgRangedGroup.addPerk("perk.hd_hybridization", 3);	// Add Hybridization (New Hardened Perk) into the Tier 3
		pgRangedGroup.addPerk("perk.rf_marksmanship", 7);
	}

	{	// Shield Group
		local pgShieldGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_shield");
		pgShieldGroup.removePerk("perk.duelist");		// Remove Duelist from Shields
		pgShieldGroup.addPerk("perk.hd_one_with_the_shield", 7);		// Add One with the Shield (New Hardened Perk) into the Tier 7
	}

	{	// Soldier Group
		local pgSoldierGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_soldier");
		pgSoldierGroup.addPerk("perk.rally_the_troops", 3);		// Add Rally the Troops into the Tier 3
	}

	{	// Spear Group
		local pgSpearGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_spear");
		changePerkTier(pgSpearGroup, "perk.rf_king_of_all_weapons", 6);	// Move "Spear Flurry" to Tier 6 (down from Tier 7)
	}

	{	// Special Marksman Group
		::DynamicPerks.PerkGroups.remove("pg.special.rf_marksmanship");	// This group does no longer exist in Hardened
	}

	{	// Special Student Group
		::DynamicPerks.PerkGroups.remove("pg.special.rf_student");	// This group does no longer exist in Hardened
	}

	{	// Swift Strikes Group
		local pgSwiftPerkGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_swift");
		pgSwiftPerkGroup.removePerk("perk.rf_vigorous_assault");	// Remove Vigorous Assault
		pgSwiftPerkGroup.addPerk("perk.hd_elusive", 2);			// Add Elusive (New Hardened Perk) into the Tier 2
		pgSwiftPerkGroup.addPerk("perk.hd_parry", 3);			// Add Parry (New Hardened Perk) into the Tier 3
	}

	{	// Tactician Group
		::DynamicPerks.PerkGroups.remove("pg.rf_tactician");
		::DynamicPerks.PerkGroups.add(::new("scripts/mods/mod_hardened/perk_groups/special/pg_special_hd_tactician"));		// We introduce our own special Tactician Group
	}

	{	// Throwing Group
		local pgThrowingPerkGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_throwing");
		changePerkTier(pgThrowingPerkGroup, "perk.rf_hybridization", 2);		// Move Hybridization (now Toolbox) to tier 2 (down from Tier 3)
	}

	{	// Wildling Group
		local pgWildling = ::DynamicPerks.PerkGroups.findById("pg.rf_wildling");
		pgWildling.removePerk("perk.rf_bestial_vigor");	// Remove Bestial Vigor (now Backup Plan) from Wildling
		pgWildling.removePerk("perk.pathfinder");
		pgWildling.addPerk("perk.colossus", 1);
		pgWildling.getPerkGroupMultiplier = function( _groupID, _perkTree )
		{
			switch (_groupID)
			{
				case "pg.rf_ranged":
					return 0.5;		// In Reforged this is 0
				case "pg.special.rf_gifted":
					return 1.0;		// In Reforged this is 0
				case "pg.special.rf_leadership":
					return 0.5;		// In Reforged this is 0
			}
		}
	}
}

// Re-calculate the perk groups listed on the perks
// This is a 1:1 copy of how dynamic perks does it. There is currently no API to force that calculation again in a cleaner way via DP mod
foreach (perk in ::Const.Perks.LookupMap)
{
	perk.PerkGroupIDs <- [];
}

local tooltipImageKeywords = {};
foreach (perkGroup in ::DynamicPerks.PerkGroups.getAll())
{
	foreach (row in perkGroup.getTree())
	{
		foreach (perkID in row)
		{
			::Const.Perks.findById(perkID).PerkGroupIDs.push(perkGroup.getID());
		}
	}
}
::DynamicPerks.Mod.Tooltips.setTooltipImageKeywords(tooltipImageKeywords);
