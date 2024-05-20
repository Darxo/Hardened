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

	::DynamicPerks.addPerkGroupToTooltips();	// Update all perk tooltips to reflect the possible changes done to them by moving them around
}
