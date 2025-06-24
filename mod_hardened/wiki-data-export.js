// Compare Vanilla Helmets with Reforged Helmets
{
	// Step 1: Fetch Vanilla Stats:
	{
		local scriptFiles = this.IO.enumerateFiles("scripts/items/helmets/");
		local instantiatedHelmets = [];
		foreach (scriptFile in scriptFiles)
		{
			if (scriptFile.find("/rf_") != null) continue;
			if (scriptFile.find("/golems/") != null) continue;
			if (scriptFile.find("/greenskins/") != null) continue;
			if (scriptFile.find("/legendary/") != null) continue;
			if (scriptFile.find("/named/") != null) continue;
			if (scriptFile == "scripts/items/helmets/helmet") continue;		// We skip the base class
			try {
				local newHelmet = ::new(scriptFile);
				if (!newHelmet.m.IsDroppedAsLoot) continue;		// indicator that this is a special helmet
				instantiatedHelmets.push(newHelmet);
			}
			catch ( _ex ) {}	// Do nothing
		}
		instantiatedHelmets.sort(@(a, b) (a.getConditionMax() <=> b.getConditionMax()));

		local output = "";
		local separater = "|";
		foreach (helmet in instantiatedHelmets)
		{
			output += ::IO.scriptFilenameByHash(helmet.ClassNameHash) + separater;
			output += helmet.getName() + separater;
			output += helmet.getConditionMax() + separater;
			output += (-1 * helmet.getStaminaModifier()) + separater;
			output += helmet.m.Vision + separater;
			output += helmet.getValue() + ";";
		}
		::logWarning(output);
	}

	// Step 2: Fetch Reforged Stats:
	{
		local scriptFiles = this.IO.enumerateFiles("scripts/items/helmets/");
		local instantiatedHelmets = [];
		foreach (scriptFile in scriptFiles)
		{
			if (scriptFile.find("/rf_") == null) continue;
			if (scriptFile.find("/golems/") != null) continue;
			if (scriptFile.find("/greenskins/") != null) continue;
			if (scriptFile.find("/legendary/") != null) continue;
			if (scriptFile.find("/named/") != null) continue;
			if (scriptFile == "scripts/items/helmets/helmet") continue;		// We skip the base class
			try {
				local newHelmet = ::new(scriptFile);
				if (!newHelmet.m.IsDroppedAsLoot) continue;		// indicator that this is a special helmet
				instantiatedHelmets.push(newHelmet);
			}
			catch ( _ex ) {}	// Do nothing
		}
		instantiatedHelmets.sort(@(a, b) (a.getConditionMax() <=> b.getConditionMax()));

		local output = "";
		local separater = "|";
		foreach (helmet in instantiatedHelmets)
		{
			output += ::IO.scriptFilenameByHash(helmet.ClassNameHash) + separater;
			output += helmet.getName() + separater;
			output += helmet.getConditionMax() + separater;
			output += (-1 * helmet.getStaminaModifier()) + separater;
			output += helmet.m.Vision + separater;
			output += helmet.getValue() + ";";
		}
		::logWarning(output);
	}

	// Step 3: Create Comparison between old and new vanilla stats:
	{
		local helmetRawData = "scripts/items/helmets/rf_scale_helmet|Scale Helmet|90|5|-1|300;scripts/items/helmets/rf_skull_cap|Skull Cap|115|5|-1|800;scripts/items/helmets/rf_padded_scale_helmet|Padded Scale Helmet|115|7|-1|375;scripts/items/helmets/rf_skull_cap_with_rondels|Skull Cap with Rondels|130|6|-1|1000;scripts/items/helmets/rf_padded_skull_cap|Padded Skull Cap|140|7|-1|1200;scripts/items/helmets/rf_sallet_helmet|Sallet Helmet|150|7|-1|1500;scripts/items/helmets/rf_padded_skull_cap_with_rondels|Padded Skull Cap with Rondels|160|8|-1|1500;scripts/items/helmets/rf_greatsword_helm|Duelist's Helmet|160|7|-1|2000;scripts/items/helmets/rf_padded_sallet_helmet|Padded Sallet Helmet|180|9|-1|2000;scripts/items/helmets/rf_half_closed_sallet|Half Closed Sallet|200|10|-2|2400;scripts/items/helmets/rf_skull_cap_with_mail|Skull Cap with Mail|210|12|-2|2000;scripts/items/helmets/rf_conical_billed_helmet|Conical Billed Helmet|220|12|-2|2500;scripts/items/helmets/rf_sallet_helmet_with_mail|Sallet Helmet with Mail|240|14|-2|2500;scripts/items/helmets/rf_padded_conical_billed_helmet|Padded Conical Billed Helmet|245|14|-2|2900;scripts/items/helmets/rf_closed_bascinet|Closed Bascinet with Mail|260|17|-3|2400;scripts/items/helmets/rf_sallet_helmet_with_bevor|Sallet Helmet with Bevor|275|17|-2|3500;scripts/items/helmets/rf_half_closed_sallet_with_mail|Half Closed Sallet with Mail|290|18|-2|4000;scripts/items/helmets/rf_visored_bascinet|Visored Bascinet|300|19|-3|4500;scripts/items/helmets/rf_half_closed_sallet_with_bevor|Half Closed Sallet with Bevor|315|20|-3|5000;scripts/items/helmets/rf_snubnose_bascinet_with_mail|Snubnose Bascinet with Mail|330|21|-3|5500;scripts/items/helmets/rf_hounskull_bascinet_with_mail|Hounskull Bascinet with Mail|340|22|-3|6000;scripts/items/helmets/rf_great_helm|Great Helm|360|26|-4|4500;";
		local helmetRawData = "scripts/items/helmets/mouth_piece|Mouth Piece|10|0|0|15;scripts/items/helmets/headscarf|Headscarf|20|0|0|30;scripts/items/helmets/hood|Hood|30|0|0|40;scripts/items/helmets/straw_hat|Straw Hat|30|0|0|60;scripts/items/helmets/barbarians/leather_headband|Leather Headband|30|0|0|30;scripts/items/helmets/cultist_hood|Cultist Hood|30|0|-1|20;scripts/items/helmets/jesters_hat|Jester's Hat|30|0|0|70;scripts/items/helmets/hunters_hat|Hunter's Hat|30|0|0|70;scripts/items/helmets/oriental/engineer_hat|Engineer's Hat|30|0|0|50;scripts/items/helmets/oriental/gunner_hat|Gunner's Hat|30|0|0|50;scripts/items/helmets/wizard_hat|Wizard's Hat|30|0|0|30;scripts/items/helmets/feathered_hat|Feathered Hat|30|0|0|80;scripts/items/helmets/oriental/southern_head_wrap|Southern Head Wrap|30|0|0|50;scripts/items/helmets/oriental/nomad_head_wrap|Nomad Head Wrap|30|0|0|40;scripts/items/helmets/oriental/leather_head_wrap|Leather Head Wrap|40|2|0|60;scripts/items/helmets/witchhunter_hat|Witchhunter's Hat|40|0|0|100;scripts/items/helmets/open_leather_cap|Open Leather Cap|40|2|0|60;scripts/items/helmets/aketon_cap|Aketon Cap|40|1|0|70;scripts/items/helmets/dark_cowl|Dark Cowl|40|0|0|100;scripts/items/helmets/oriental/assassin_head_wrap|Assassin's Head Wrap|40|0|0|60;scripts/items/helmets/undertaker_hat|Undertaker's Hat|40|0|0|120;scripts/items/helmets/full_leather_cap|Full Leather Cap|45|3|0|80;scripts/items/helmets/oriental/desert_stalker_head_wrap|Desert Stalker's Head Wrap|45|0|0|120;scripts/items/helmets/full_aketon_cap|Full Aketon Cap|50|2|0|100;scripts/items/helmets/barbarians/bear_headpiece|Bear Headpiece|50|3|0|100;scripts/items/helmets/oriental/nomad_leather_cap|Nomad Leather Cap|50|2|0|110;scripts/items/helmets/cultist_leather_hood|Cultist Leather Hood|60|3|-1|140;scripts/items/helmets/oriental/blade_dancer_head_wrap|Blade Dancer's Head Wrap|60|1|0|150;scripts/items/helmets/oriental/nomad_light_helmet|Nomad Light Helmet|70|3|0|140;scripts/items/helmets/rusty_mail_coif|Rusty Mail Coif|70|4|0|150;scripts/items/helmets/greatsword_hat|Duelist's Hat|70|3|0|200;scripts/items/helmets/physician_mask|Physician's Mask|70|3|-1|170;scripts/items/helmets/mail_coif|Mail Coif|80|4|0|200;scripts/items/helmets/closed_mail_coif|Closed Mail Coif|90|4|0|250;scripts/items/helmets/ancient/ancient_household_helmet|Ancient Household Helmet|95|8|-1|250;scripts/items/helmets/reinforced_mail_coif|Reinforced Mail Coif|100|5|-1|300;scripts/items/helmets/oriental/wrapped_southern_helmet|Wrapped Southern Helmet|105|5|-1|350;scripts/items/helmets/nasal_helmet|Nasal Helmet|105|5|-1|350;scripts/items/helmets/barbarians/leather_helmet|Leather Helmet|105|6|-1|320;scripts/items/helmets/heavy_mail_coif|Heavy Mail Coif|110|5|0|375;scripts/items/helmets/dented_nasal_helmet|Padded Dented Nasal Helmet|110|7|-1|350;scripts/items/helmets/kettle_hat|Kettle hat|115|6|-1|450;scripts/items/helmets/sallet_helmet|Sallet Helmet|120|5|0|1200;scripts/items/helmets/masked_kettle_helmet|Masked Kettle Helmet|120|6|-2|550;scripts/items/helmets/flat_top_helmet|Flat Top Helmet|125|7|-1|500;scripts/items/helmets/oriental/nomad_reinforced_helmet|Nomad Reinforced Helmet|125|8|-1|450;scripts/items/helmets/oriental/spiked_skull_cap_with_mail|Spiked Skull Cap with Mail|125|7|-1|500;scripts/items/helmets/nordic_helmet|Nordic Helmet|125|7|-1|500;scripts/items/helmets/padded_nasal_helmet|Padded Nasal Helmet|130|7|-1|550;scripts/items/helmets/ancient/ancient_legionary_helmet|Ancient Legionary Helmet|130|10|-2|600;scripts/items/helmets/barbarians/beastmasters_headpiece|Beastmaster's Headpiece|130|8|-1|350;scripts/items/helmets/padded_kettle_hat|Padded Kettle hat|140|8|-1|650;scripts/items/helmets/nasal_helmet_with_rusty_mail|Nasal Helmet With Rusty Mail|140|9|-2|600;scripts/items/helmets/oriental/assassin_face_mask|Assassin's Face Mask|140|6|-1|1800;scripts/items/helmets/barbarians/crude_metal_helmet|Crude Metal Helmet|145|11|-1|550;scripts/items/helmets/padded_flat_top_helmet|Padded Flat Top Helmet|150|9|-1|800;scripts/items/helmets/barbarians/crude_faceguard_helmet|Crude Faceguard Helmet|160|15|-2|650;scripts/items/helmets/greatsword_faction_helm|Zweihander's Helmet|160|7|-1|850;scripts/items/helmets/closed_flat_top_helmet|Closed Flat Top Helmet|170|10|-3|1000;scripts/items/helmets/closed_flat_top_with_neckguard|Closed and Padded Flat Top|180|11|-3|1100;scripts/items/helmets/ancient/ancient_honorguard_helmet|Ancient Honor Guard Helmet|180|13|-3|1000;scripts/items/helmets/barbarians/closed_scrap_metal_helmet|Closed Scrap Metal Helmet|190|18|-2|800;scripts/items/helmets/barbute_helmet|Barbute Helmet|190|9|-2|2600;scripts/items/helmets/oriental/southern_helmet_with_coif|Southern Helmet with Coif|200|12|-2|1250;scripts/items/helmets/steppe_helmet_with_mail|Steppe Helmet with Mail|200|12|-2|1250;scripts/items/helmets/nasal_helmet_with_mail|Nasal Helmet with Mail|200|12|-2|1250;scripts/items/helmets/bascinet_with_mail|Bascinet with Mail|210|13|-2|1400;scripts/items/helmets/kettle_hat_with_mail|Kettle Hat with Mail|215|14|-2|1500;scripts/items/helmets/oriental/gladiator_helmet|Gladiator Helmet|225|13|-3|2200;scripts/items/helmets/flat_top_with_mail|Flat Top with Mail|230|15|-2|1800;scripts/items/helmets/decayed_closed_flat_top_with_mail|Decayed Closed Flat Top with Mail|230|19|-3|1250;scripts/items/helmets/decayed_closed_flat_top_with_sack|Covered Decayed Closed Flat Top with Mail|230|19|-3|1250;scripts/items/helmets/nasal_helmet_with_closed_mail|Nasal Helmet with Closed Mail|240|16|-2|2000;scripts/items/helmets/decayed_full_helm|Decayed Full Helm|240|20|-3|1500;scripts/items/helmets/kettle_hat_with_closed_mail|Kettle Hat with Closed Mail|250|17|-2|2200;scripts/items/helmets/barbarians/heavy_horned_plate_helmet|Heavy Horned Plate Helmet|250|23|-3|1300;scripts/items/helmets/adorned_closed_flat_top_with_mail|Adorned Closed Flat Top|250|15|-3|2000;scripts/items/helmets/oriental/heavy_lamellar_helmet|Heavy Lamellar Helmet|255|17|-2|2500;scripts/items/helmets/decayed_great_helm|Decayed Great Helm|255|22|-3|2000;scripts/items/helmets/flat_top_with_closed_mail|Flat Top with Closed Mail|265|18|-2|2600;scripts/items/helmets/conic_helmet_with_closed_mail|Conic Helmet with Closed Mail|265|18|-2|2600;scripts/items/helmets/nordic_helmet_with_closed_mail|Nordic Helmet with Closed Mail|265|18|-2|2600;scripts/items/helmets/closed_flat_top_with_mail|Closed Flat Top with Mail|280|19|-3|3000;scripts/items/helmets/conic_helmet_with_faceguard|Conic Helmet with Faceguard|280|19|-3|3000;scripts/items/helmets/oriental/turban_helmet|Turban Helmet|290|20|-3|3200;scripts/items/helmets/full_helm|Full Helm|300|20|-3|3500;scripts/items/helmets/adorned_full_helm|Adorned Full Helm|300|18|-3|3700;scripts/items/helmets/faction_helm|Decorated Full Helm|320|21|-3|4000;";

		local oldHelmetStats = [];
		foreach (helmetLine in split(helmetRawData, ";"))
		{
			local helmetStats = split(helmetLine, "|");
			local helmetEntry = {
				ClassName = helmetStats[0],
				Name = helmetStats[1],
				ConditionMax = helmetStats[2],
				Weight = helmetStats[3],
				Vision = helmetStats[4],
				Value = helmetStats[5],
			}
			oldHelmetStats.push(helmetEntry);
		}

		local hardenedHelmetStats = {};

		local scriptFiles = this.IO.enumerateFiles("scripts/items/helmets/");
		local instantiatedHelmets = [];
		foreach (scriptFile in scriptFiles)
		{
			// if (scriptFile.find("/rf_") != null) continue;	// Toggle this depending on what

			if (scriptFile.find("/golems/") != null) continue;
			if (scriptFile.find("/greenskins/") != null) continue;
			if (scriptFile.find("/legendary/") != null) continue;
			if (scriptFile.find("/named/") != null) continue;
			if (scriptFile == "scripts/items/helmets/helmet") continue;		// We skip the base class
			try {
				local newHelmet = ::new(scriptFile);
				if (!newHelmet.m.IsDroppedAsLoot) continue;		// indicator that this is a special helmet
				hardenedHelmetStats[::IO.scriptFilenameByHash(newHelmet.ClassNameHash)] <- newHelmet;
			}
			catch ( _ex ) {}	// Do nothing
		}

		local output = "";
		foreach (oldHelmet in oldHelmetStats)
		{
			local newHelmetStats = hardenedHelmetStats[oldHelmet.ClassName];
			output += oldHelmet.Name + " | ";
			output += oldHelmet.ConditionMax + " | ";
			output += oldHelmet.Weight + " | ";
			output += oldHelmet.Vision + " | ";
			output += oldHelmet.Value + " | ";
			output += newHelmetStats.getConditionMax() + " | ";
			output += newHelmetStats.getWeight() + " | ";
			output += newHelmetStats.m.Vision + " | ";
			output += newHelmetStats.getValue() + "\n";
		}
		::logWarning(output);

		oldHelmetStats.sort(@(a, b) (a.Name <=> b.Name));

		// Generate Readme notes for the helmets
		local patchnotes = "";
		foreach (oldHelmet in oldHelmetStats)
		{
			local newHelmetStats = hardenedHelmetStats[oldHelmet.ClassName];

			patchnotes += "- **" + oldHelmet.Name + "** now has ";

			if (oldHelmet.ConditionMax != "" + newHelmetStats.getConditionMax())
			{
				patchnotes += format("%s Condition (%s from %s), ", "" + newHelmetStats.getConditionMax(), "" + newHelmetStats.getConditionMax() > oldHelmet.ConditionMax ? "up" : "down", oldHelmet.ConditionMax);
			}
			if (oldHelmet.Weight != "" + newHelmetStats.getWeight())
			{
				patchnotes += format("%s Weight (%s from %s), ", "" + newHelmetStats.getWeight(), "" + newHelmetStats.getWeight() > oldHelmet.Weight ? "up" : "down", oldHelmet.Weight);
			}
			if (oldHelmet.Vision != "" + newHelmetStats.m.Vision)
			{
				patchnotes += format("%s Vision (%s from %s)", "" + newHelmetStats.m.Vision, "" + newHelmetStats.m.Vision > oldHelmet.Vision ? "up" : "down", oldHelmet.Vision);
			}
			if (oldHelmet.Value != "" + newHelmetStats.getValue())
			{
				patchnotes += format(" and costs %s Crowns (%s from %s)", "" + newHelmetStats.getValue(), "" + newHelmetStats.getValue() > oldHelmet.Value ? "up" : "down", oldHelmet.Value);
			}
			patchnotes += "\n";
		}
		// ::logWarning(patchnotes);
	}
}
