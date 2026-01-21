/*
Regular hooking of Perk Groups does not work because they are instantiated before any hooks run
They are pushed into ::DynamicPerks.PerkGroups during the execution of scripts/mods/mod_reforged/load.nut
Therefor the only way we can "hook" them is by fetching and changing the instantiated objects from the Lookup Maps
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

	{	// Cleaver Group
		local pgCleaverGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_cleaver");
		changePerkTier(pgCleaverGroup, "perk.rf_mauler", 2);		// Move Mauler to Tier 2 (down from Tier 6)
		changePerkTier(pgCleaverGroup, "perk.rf_sanguinary", 6);	// Move Sanguinary to Tier 6 (up from Tier 2)
	}

	{	// Fast Group
		local pgFastGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_fast");
		pgFastGroup.removePerk("perk.rf_dynamic_duo");					// Remove Dynamic Duo from Fast group as it moved to agile group
		pgFastGroup.addPerk("perk.rf_wear_them_down", 3);				// Add Wear them Down to Tier 3
	}

	{	// Fencer Group
		local pgFencerGroup = ::DynamicPerks.PerkGroups.findById("pg.special.rf_fencer");
		pgFencerGroup.addPerk("perk.footwork", 1);				// Add Footwork to Tier 1
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
					return 1.0;		// In Reforged this is -1
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

	{	// Man of Steel Group
		local pgManOfSteel = ::DynamicPerks.PerkGroups.findById("pg.special.rf_man_of_steel");
		changePerkTier(pgManOfSteel, "perk.rf_man_of_steel", 3);			// Move Man of Steel to Tier 3 (down from Tier 7)
	}

	{	// Militia Group
		local pgMilitia = ::DynamicPerks.PerkGroups.findById("pg.rf_militia");
		changePerkTier(pgMilitia, "perk.rf_phalanx", 3);			// Move "Phalanx" to Tier 3 (up from Tier 1)
	}

	{	// Net Group
		local pgNetGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_trapper");
		changePerkTier(pgNetGroup, "perk.rf_angler", 2);			// Move Angler from Tier 3 down to Tier 2
	}

	{	// Noble Group
		local pgNobleGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_noble");
		pgNobleGroup.addPerk("perk.inspiring_presence", 7);		// Add Inspiring Presence to Tier 7
	}

	{	// Polearm Group
		local pgPolearmGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_polearm");
		changePerkTier(pgPolearmGroup, "perk.rf_long_reach", 2);	// Move "Long Reach" to Tier 2 (down from Tier 7)
		changePerkTier(pgPolearmGroup, "perk.rf_leverage", 7);		// Move "Leverage" to Tier 7 (up from Tier 3)
	}

	{	// Power Group
		local pgPowerGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_power");
		pgPowerGroup.addPerk("perk.rf_death_dealer", 6);	// Add Death Dealer to Tier 6
		pgPowerGroup.addPerk("perk.colossus", 1);			// Add Colossus to Tier 1
		pgPowerGroup.removePerk("perk.crippling_strikes");	// Remove Crippling Strikes from Tier 1
	}

	{	// Raider Group
		local pgRaiderGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_raider");
		changePerkTier(pgRaiderGroup, "perk.rf_bully", 1);		// Move "Billy" to Tier 1 (down from Tier 2)
		changePerkTier(pgRaiderGroup, "perk.rf_menacing", 3);		// Move "Menacing" to Tier 3 (up from Tier 1)
	}

	{	// Ranged Group
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
		pgShieldGroup.addPerk("perk.hd_one_with_the_shield", 1);		// Add One with the Shield (New Hardened Perk) into the Tier 1

		changePerkTier(pgShieldGroup, "perk.rf_exploit_opening", 2);	// Move "Exploit Opening" to Tier 2 (up from Tier 1)
		changePerkTier(pgShieldGroup, "perk.rf_phalanx", 3);			// Move "Phalanx" to Tier 3 (up from Tier 2)
		changePerkTier(pgShieldGroup, "perk.shield_expert", 4);			// Move "Shield Expert" to Tier 4 (up from Tier 3)
		changePerkTier(pgShieldGroup, "perk.rf_line_breaker", 5);		// Move "Line Breaker" to Tier 5 (up from Tier 4)
		changePerkTier(pgShieldGroup, "perk.rf_rebuke", 7);				// Move "Rebuke" to Tier 7 (up from Tier 5)
	}

	{	// Soldier Group
		local pgSoldierGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_soldier");
		pgSoldierGroup.addPerk("perk.rally_the_troops", 3);		// Add Rally the Troops into the Tier 3

		pgSoldierGroup.removePerk("perk.rf_exude_confidence");		// Remove Exude Confidence from Tier 4 (as it needs to move over to Vigorous)
		pgSoldierGroup.addPerk("perk.rf_decisive", 4);				// Add Decisive into Tier 4 (to still have it available after removing it from Vigorous)

		// Overwrite, because we remove the guaranteed "Professional" and turn guaranteed "Trained" into a 2.5x multiplier
		pgSoldierGroup.getPerkGroupMultiplier = function( _groupID, _perkTree )
		{
			switch (_groupID)
			{
				case "pg.rf_trained":
					return 2.5;	// In Reforged this is guaranteed
				case "pg.special.rf_back_to_basics":
					return 2.5;	// Same as Reforged
			}
		}
	}

	{	// Spear Group
		local pgSpearGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_spear");
		changePerkTier(pgSpearGroup, "perk.rf_through_the_gaps", 2);	// Move "Through the Gaps" to Tier 2 (down from Tier 3)
		changePerkTier(pgSpearGroup, "perk.rf_king_of_all_weapons", 6);	// Move "Spear Flurry" to Tier 6 (down from Tier 7)
	}

	{	// Special Marksman Group
		::DynamicPerks.PerkGroups.remove("pg.special.rf_marksmanship");	// This group does no longer exist in Hardened
	}

	{	// Special Rising Star Group
		local pgRisingStarGroup = ::DynamicPerks.PerkGroups.findById("pg.special.rf_rising_star");
		changePerkTier(pgRisingStarGroup, "perk.rf_rising_star", 6);		// Move Rising Star  to tier 6 (down from Tier 7)
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

	{	// Trained Group
		local pgTrained = ::DynamicPerks.PerkGroups.findById("pg.rf_trained");
		pgTrained.removePerk("perk.rotation");	// Remove Rotation from Tier 3
		changePerkTier(pgTrained, "perk.underdog", 3)	// Move Underdog from Tier 5 to Tier 3
		pgTrained.addPerk("perk.hd_warden", 5);	// Add new Warden perk to Tier 5
	}

	{	// Tough Group
		local pgToughGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_tough");
		pgToughGroup.removePerk("perk.colossus");				// Remove Colossus from Tier 1
		pgToughGroup.addPerk("perk.rf_survival_instinct", 1);	// Add Survival Instinct into Tier 1
		pgToughGroup.m.Icon = "ui/perks/perk_36.png";			// Change Icon to "Killing Frenzy"; In Reforged this is Colossus
	}

	{	// Unstoppable Group
		local pgUnstoppablePerkGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_unstoppable");
		pgUnstoppablePerkGroup.addPerk("perk.hd_anchor", 3);	// Add Anchor (New Hardened Perk) into the Tier 3
	}

	{	// Vicious Group
		local pgViciousGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_vicious");

		pgViciousGroup.removePerk("perk.rf_between_the_eyes");		// Remove Between the Eyes from Tier 3
		pgViciousGroup.addPerk("perk.hd_brace_for_impact", 3);		// Add Brace for Impact (New Hardened Perk) into Tier 3

		changePerkTier(pgViciousGroup, "perk.berserk", 7);		// Move Berserk to Tier 7 (up from Tier 5)
		changePerkTier(pgViciousGroup, "perk.fearsome", 5);		// Move Fearsome to Tier 5 (down from Tier 7)
	}

	{	// Vigorous Group
		local pgVigorousGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_vigorous");
		pgVigorousGroup.removePerk("perk.rf_survival_instinct");	// Remove Survival Instinct from Tier 1
		pgVigorousGroup.addPerk("perk.crippling_strikes", 1);		// Add Crippling Strikes into Tier 1

		pgVigorousGroup.removePerk("perk.rf_decisive");				// Remove Decisive from Tier 4 (to prevent easy perma indom)
		pgVigorousGroup.addPerk("perk.rf_exude_confidence", 4);		// Add Exude Confidence into Tier 4 (just to fill the gap from missing Decisive)
	}

	{	// Wildling Group
		local pgWildling = ::DynamicPerks.PerkGroups.findById("pg.rf_wildling");
		pgWildling.removePerk("perk.rf_bestial_vigor");	// Remove Bestial Vigor (now Backup Plan) from Wildling
		pgWildling.removePerk("perk.pathfinder");
		pgWildling.addPerk("perk.crippling_strikes", 1);		// Add Crippling Strikes into Tier 1
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
