// Todo: explanation why this file has to be in afterhooks bucket

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
	}

	{	// Axe Group
		local pgAxeGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_axe");
		changePerkTier(pgAxeGroup, "perk.rf_dismemberment", 2);		// Move Dismantle to Tier 2 (up from Tier 6)
		changePerkTier(pgAxeGroup, "perk.rf_dismantle", 6);			// Move Dismantle to Tier 6 (up from Tier 2)
	}

	{	// Fast Group
		local pgFastGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_fast");
		changePerkTier(pgFastGroup, "perk.rf_combo", 5);				// Move Combo to Tier 5 (down from Tier 7)
		changePerkTier(pgFastGroup, "perk.rf_calculated_strikes", 7);	// Calculated Strikes to Tier 7 (up from Tier 5)
	}

	{	// Hammer Group
		local pgHammerArmorGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_hammer");
		changePerkTier(pgHammerArmorGroup, "perk.rf_rattle", 6);			// Move rattle (Full Force) into the position where Deep Impact was previously
		changePerkTier(pgHammerArmorGroup, "perk.rf_deep_impact", 3);	// Move Deep Impact into the position where Rattle (Full Force) was previously
	}

	{	// Knave Group
		local pgKnaveGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_knave");
		changePerkTier(pgKnaveGroup, "perk.rf_cheap_trick", 1);			// Move "Cheap Trick" to Tier 1 (down from Tier 2)
		changePerkTier(pgKnaveGroup, "perk.rf_tricksters_purses", 3);		// Move "Tricksters Purses" to Tier 3 (up from Tier 1)
		changePerkTier(pgKnaveGroup, "perk.rf_ghostlike", 5);				// Move "Ghostlike" to Tier 5 (up from Tier 4)
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

	{	// Ranged Combat
		local pgRangedGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_ranged");
		pgRangedGroup.addPerk("perk.rf_through_the_ranks", 1);	// Add Through the Ranks (Scout) into the Tier 1
		pgRangedGroup.addPerk("perk.rf_marksmanship", 7);
	}

	{	// Shield Group
		local pgShieldGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_shield");
		pgShieldGroup.removePerk("perk.duelist");		// Remove Duelist fomr Shields
		pgShieldGroup.addPerk("perk.recover", 7);		// Add Recover (One with the Shield) into the Tier 7
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
		pgSwiftPerkGroup.addPerk("perk.rf_trip_artist", 2);		// Add Trip Artist (Elusive) into the Tier 2
		pgSwiftPerkGroup.addPerk("perk.reach_advantage", 3);			// Add Reach Advantage (Parry) into the Tier 3
	}

	{	// Tactician Group
		::DynamicPerks.PerkGroups.remove("pg.rf_tactician");
		::DynamicPerks.PerkGroups.add(::new("scripts/mods/mod_hardened/perk_groups/special/pg_special_hd_tactician"));		// We introduce our own special Tactician Group
	}

	{	// Throwing Group
		local pgThrowingPerkGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_throwing");
		changePerkTier(pgThrowingPerkGroup, "perk.rf_hybridization", 2);		// Move Hybridization (now Toolbox) to tier 2 (down from Tier 3)
	}

	{	// Trained Group
		local pgTrainedGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_trained");
		changePerkTier(pgTrainedGroup, "perk.quick_hands", 1);			// Move Quickhands down to the lowest tier
	}

	{	// Wildling Group
		local pgWildling = ::DynamicPerks.PerkGroups.findById("pg.rf_wildling");
		pgWildling.removePerk("perk.rf_bestial_vigor");	// Remove Bestial Vigor (now Backup Plan) from Wildling
		pgWildling.removePerk("perk.pathfinder");
		pgWildling.addPerk("perk.colossus", 1);
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
