// Adjust Reforged Perk Groups
{
	// Always Group
	local pgAlwaysGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_always_1");
	pgAlwaysGroup.getTree()[0].push("perk.student");	// Add Student
	foreach (row in pgAlwaysGroup.getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.bags_and_belts") row.remove(i);		// Remove Bags and Belts
		}
	}

	// Hammer Group
	local pgHammerArmorGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_hammer");
	foreach (row in pgHammerArmorGroup.getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.rf_rattle")
			{
				row[i] = "perk.rf_deep_impact";		// Move Deep Impact into the position where Rattle (Full Force) was previously
			}
			else if (perk == "perk.rf_deep_impact")
			{
				row[i] = "perk.rf_rattle";		// Move rattle (Full Force) into the position where Deep Impact was previously
			}
		}
	}

	// Laborer Group
	foreach (row in ::DynamicPerks.PerkGroups.findById("pg.rf_laborer").getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.bags_and_belts") row.remove(i);		// Remove Bags and Belts
		}
	}

	// Light Armor Group
	local pgLightArmorGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_light_armor");
	pgLightArmorGroup.getTree()[0].push("perk.bags_and_belts");	// Add Bags and Belts
	foreach (row in pgLightArmorGroup.getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.dodge") row.remove(i);	// Remove Dodge
		}
	}

	// Leadership
	local pgLeadership = ::DynamicPerks.PerkGroups.findById("pg.special.rf_leadership");
	foreach (row in pgLeadership.getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.mastery.polearm") row.remove(i);	// Remove Polearm Mastery
		}
	}

	// Noble
	local pgNobleGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_noble");
	pgNobleGroup.getTree()[6].push("perk.inspiring_presence");	// Add Inspiring Presence to Tier 7

	// Swift Strikes
	local pgSwiftPerkGroup = ::DynamicPerks.PerkGroups.findById("pg.rf_swift");
	pgSwiftPerkGroup.getTree()[2].push("perk.reach_advantage");	// Add Reach Advantage (Parry) into the Tier 3 row
	foreach (row in pgSwiftPerkGroup.getTree())
	{
		foreach (i, perk in row)
		{
			if (perk == "perk.rf_vigorous_assault") row.remove(i);	// Remove Vigorous Assault
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
			::logWarning("Push " + perkGroup.getID() + " into the perk " + perkID);
			::Const.Perks.findById(perkID).PerkGroupIDs.push(perkGroup.getID());
		}
	}
	if (perkGroup.getIcon() != "")
	{
		tooltipImageKeywords[perkGroup.getIcon()] <- "PerkGroup+" + perkGroup.getID();
	}
}
::DynamicPerks.Mod.Tooltips.setTooltipImageKeywords(tooltipImageKeywords);
