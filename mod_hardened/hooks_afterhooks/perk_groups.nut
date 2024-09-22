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
}
