{	// Balanced
	// scripts/entity/tactical/enemies/bandit_thug
	::Reforged.Entities.editEntity("BanditThug",
		{
			Cost = 10, 		// Reforged: 9; Vanilla: 9
			Strength = 10, 	// Reforged: 9; Vanilla: 9
		},
		{
			XP = 100 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 120; Vanilla 150
			Hitpoints = 55, // Reforged: 55
			Bravery = 40, // Reforged: 40
			Stamina = 100, // Reforged: 95
			MeleeSkill = 55, // Reforged: 55
			RangedSkill = 40, // Reforged: 45
			MeleeDefense = 5,	// Reforged: 0
			RangedDefense = 0, // Reforged: 0
			Initiative = 100,	// Reforged: 95
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_pillager
	::Reforged.Entities.editEntity("RF_BanditPillager",
		{
			Cost = 16, 		// Reforged: 18
			Strength = 16, 	// Reforged: 18
		},
		{
			XP = 160 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 120; Vanilla 150
			Hitpoints = 65, // Reforged: 75
			Bravery = 50, // Reforged: 50
			Stamina = 115, // Reforged: 115
			MeleeSkill = 65, // Reforged: 65
			RangedSkill = 55, // Reforged: 55
			MeleeDefense = 5,	// Reforged: 10
			RangedDefense = 0, // Reforged: 0
			Initiative = 100,	// Reforged: 105
		}
	);

	// scripts/entity/tactical/enemies/bandit_raider
	::Reforged.Entities.editEntity("BanditRaider",
		{
			Cost = 24, 		// Reforged: 22; Vanilla: 20
			Strength = 24, 	// Reforged: 28; Vanilla: 20
		},
		{
			XP = 240 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 250; Vanilla 250
			Hitpoints = 75, // Reforged: 80; Vanilla: 75
			Bravery = 60, // Reforged: 60; Vanilla: 55
			Stamina = 125, // Reforged: 125
			MeleeSkill = 75, // Reforged: 72
			RangedSkill = 60, // Reforged: 60
			MeleeDefense = 10,	// Reforged: 10
			RangedDefense = 0, // Reforged: 0
			Initiative = 110,	// Reforged: 110; Vanilla: 115
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_marauder
	::Reforged.Entities.editEntity("RF_BanditMarauder",
		{
			Cost = 35, 		// Reforged: 26
			Strength = 35, 	// Reforged: 36
		},
		{
			XP = 350 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 300
			Hitpoints = 85, // Reforged: 85
			Bravery = 70, // Reforged: 70
			Stamina = 130, // Reforged: 130
			MeleeSkill = 85, // Reforged: 80
			RangedSkill = 65, // Reforged: 65
			MeleeDefense = 15,	// Reforged: 15
			RangedDefense = 0, // Reforged: 0
			Initiative = 110,	// Reforged: 115
		}
	);
}

{	// Ranged
	// scripts/entity/tactical/enemies/bandit_marksman
	::Reforged.Entities.editEntity("BanditPoacher",
		null,	// In Vanilla the BanditPoacher spawnlist entry is called "BanditMarksmanLOW", so we cant adjust those stats here
		{
			XP = 120 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 150; Vanilla 175
			Hitpoints = 55, // Reforged: 55; Vanilla: 60
			Bravery = 40, // Reforged: 40
			Stamina = 80, // Reforged: 95
			MeleeSkill = 40, // Reforged: 50
			RangedSkill = 60, // Reforged: 50
			MeleeDefense = 0,	// Reforged: 0
			RangedDefense = 5, // Reforged: 5
			Initiative = 80,	// Reforged: 95
			Vision = 8,		// Reforged: 7
		}
	);

	// scripts/entity/tactical/enemies/bandit_poacher
	::Reforged.Entities.editEntity("BanditMarksmanLOW",
		{
			Cost = 12, 		// Reforged: 9; Vanilla: 9
			Strength = 12, 	// Reforged: 9; Vanilla: 9
		}
	);

	// scripts/entity/tactical/enemies/bandit_marksman
	::Reforged.Entities.editEntity("BanditMarksman",
		{
			Cost = 20, 		// Reforged: 18; Vanilla: 15
			Strength = 20, 	// Reforged: 18; Vanilla: 15
		},
		{
			XP = 200 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 225; Vanilla 225
			Hitpoints = 65, // Reforged: 60; Vanilla: 60
			Bravery = 50, // Reforged: 50; Vanilla 50
			Stamina = 115, // Reforged: 105; Vanilla: 115
			MeleeSkill = 50, // Reforged: 50; Vanilla 50
			RangedSkill = 65, // Reforged: 70; Vanilla 60
			MeleeDefense = 5,	// Reforged: 0
			RangedDefense = 15, // Reforged: 10; Vanilla 10
			Initiative = 100,	// Reforged: 110
			Vision = 8,		// Reforged: 7
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_sharpshooter
	::Reforged.Entities.editEntity("RF_BanditSharpshooter",
		{
			Cost = 35, 		// Reforged: 30
			Strength = 35, 	// Reforged: 30
		},
		{
			XP = 350 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 275
			Hitpoints = 70, // Reforged: 65
			Bravery = 55, // Reforged: 55
			Stamina = 130, // Reforged: 115
			MeleeSkill = 60, // Reforged: 55
			RangedSkill = 80, // Reforged: 70
			MeleeDefense = 10,	// Reforged: 5
			RangedDefense = 15, // Reforged: 15
			Initiative = 100,	// Reforged: 115
			Vision = 8,		// Reforged: 7
		}
	);
}

{	// Tough
	// scripts/entity/tactical/enemies/rf_bandit_pillager_tough
	::Reforged.Entities.editEntity("RF_BanditPillagerTough",
		{
			Cost = 18, 		// Reforged: 18
			Strength = 18, 	// Reforged: 20
		},
		{
			XP = 180 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 200
			Hitpoints = 110, // Reforged: 110
			Bravery = 60, // Reforged: 60
			Stamina = 120, // Reforged: 115
			MeleeSkill = 65, // Reforged: 65
			RangedSkill = 25, // Reforged: 45
			MeleeDefense = 5,	// Reforged: 0
			RangedDefense = 0, // Reforged: 0
			Initiative = 60,	// Reforged: 70
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_raider_tough
	::Reforged.Entities.editEntity("RF_BanditRaiderTough",
		{
			Cost = 27, 		// Reforged: 22
			Strength = 27, 	// Reforged: 28
		},
		{
			XP = 270 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 250
			Hitpoints = 130, // Reforged: 130
			Bravery = 70, // Reforged: 70
			Stamina = 120, // Reforged: 115
			MeleeSkill = 75, // Reforged: 72
			RangedSkill = 25, // Reforged: 45
			MeleeDefense = 10,	// Reforged: 5
			RangedDefense = 0, // Reforged: 0
			Initiative = 70,	// Reforged: 75
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_marauder_tough
	::Reforged.Entities.editEntity("RF_BanditMarauderTough",
		{
			Cost = 40, 		// Reforged: 26
			Strength = 40, 	// Reforged: 36
			Variant = 2,	// Brigand Marauder can now produce Champions
			NameList = ::Const.Strings.BanditLeaderNames,	// Todo: generate unique namelist
			TitleList = null,
		},
		{
			XP = 400 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 300
			Hitpoints = 150, // Reforged: 150
			Bravery = 80, // Reforged: 80
			Stamina = 140, // Reforged: 125
			MeleeSkill = 80, // Reforged: 85
			RangedSkill = 25, // Reforged: 45
			MeleeDefense = 15,	// Reforged: 10
			RangedDefense = 0, // Reforged: 0
			Initiative = 70,	// Reforged: 80
		}
	);
}

{	// Fast
	// scripts/entity/tactical/enemies/rf_bandit_vandal
	::Reforged.Entities.editEntity("RF_BanditVandal",	// Brigand Scoundrel
		{
			Cost = 18, 		// Reforged: 18
			Strength = 18, 	// Reforged: 20
			Row = 1,		// Reforged: 0
		},
		{
			XP = 180 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 200
			Hitpoints = 60, // Reforged: 60
			Bravery = 40, // Reforged: 45
			Stamina = 100, // Reforged: 100
			MeleeSkill = 65, // Reforged: 65
			RangedSkill = 60, // Reforged: 55
			MeleeDefense = 0,	// Reforged: 0
			RangedDefense = 0, // Reforged: 0
			Initiative = 120,	// Reforged: 110
			Vision = 8,			// Reforged: 7
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_outlaw
	::Reforged.Entities.editEntity("RF_BanditOutlaw",	// Brigand Robber
		{
			Cost = 27, 		// Reforged: 22
			Strength = 27, 	// Reforged: 28
			Row = 1,		// Reforged: 0
		},
		{
			XP = 270 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 250
			Hitpoints = 65, // Reforged: 70
			Bravery = 50, // Reforged: 55
			Stamina = 110, // Reforged: 110
			MeleeSkill = 75, // Reforged: 72
			RangedSkill = 70, // Reforged: 60
			MeleeDefense = 0,	// Reforged: 10
			RangedDefense = 0, // Reforged: 5
			Initiative = 130,	// Reforged: 125
			Vision = 8,			// Reforged: 7
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_highwayman
	::Reforged.Entities.editEntity("RF_BanditHighwayman",	// Now called // Brigand Killer
		{
			Cost = 40, 		// Reforged: 26
			Strength = 40, 	// Reforged: 36
			Row = 1,		// Reforged: 0
			Variant = 2,	// Brigand Killer can now produce Champions
			NameList = ::Const.Strings.BanditLeaderNames,	// Todo: generate unique namelist
			TitleList = null,
		},
		{
			XP = 400 * ::Hardened.Global.FactionExperience.Brigands, // Reforged: 300
			Hitpoints = 70, // Reforged: 70
			Bravery = 60, // Reforged: 60
			Stamina = 120, // Reforged: 120
			MeleeSkill = 80, // Reforged: 80
			RangedSkill = 80, // Reforged: 70
			MeleeDefense = 10,	// Reforged: 15
			RangedDefense = 10, // Reforged: 10
			Initiative = 140,	// Reforged: 130
			Vision = 8,			// Reforged: 7
		}
	);
}

// scripts/entity/tactical/wardog
// scripts/entity/tactical/armored_wardog
{
	// Mandatory stats
	::Const.Tactical.Actor.Wardog.XP = 80;				// Vanilla: 75
	::Const.Tactical.Actor.Wardog.ActionPoints = 12;
	::Const.Tactical.Actor.Wardog.Hitpoints = 50;
	::Const.Tactical.Actor.Wardog.Bravery = 50;			// Vanilla: 40
	::Const.Tactical.Actor.Wardog.Stamina = 130;
	::Const.Tactical.Actor.Wardog.MeleeSkill = 40;		// Vanilla: 50
	::Const.Tactical.Actor.Wardog.RangedSkill = 0;
	::Const.Tactical.Actor.Wardog.MeleeDefense = 25;	// Vanilla: 20
	::Const.Tactical.Actor.Wardog.RangedDefense = 25;
	::Const.Tactical.Actor.Wardog.Initiative = 130;

	// Optional Stats
	::Const.Tactical.Actor.Wardog.Vision <- 5;			// Vanilla: 7
	::Const.Tactical.Actor.Wardog.Reach <- 2;
}

// scripts/entity/tactical/warhound
// scripts/entity/tactical/armored_warhound
{
	// Mandatory stats
	::Const.Tactical.Actor.Warhound.XP = 100;
	::Const.Tactical.Actor.Warhound.ActionPoints = 10;	// Vanilla: 11
	::Const.Tactical.Actor.Warhound.Hitpoints = 70;
	::Const.Tactical.Actor.Warhound.Bravery = 50;
	::Const.Tactical.Actor.Warhound.Stamina = 140;
	::Const.Tactical.Actor.Warhound.MeleeSkill = 50;	// Vanilla: 55
	::Const.Tactical.Actor.Warhound.RangedSkill = 0;
	::Const.Tactical.Actor.Warhound.MeleeDefense = 20;
	::Const.Tactical.Actor.Warhound.RangedDefense = 20;
	::Const.Tactical.Actor.Warhound.Initiative = 100;	// Vanilla: 110

	// Optional Stats
	::Const.Tactical.Actor.Warhound.Vision <- 5;		// Vanilla: 7
	::Const.Tactical.Actor.Warhound.Reach <- 2;
}

// scripts/entity/tactical/enemies/bandit_leader
{
	// Mandatory stats
	::Const.Tactical.Actor.BanditLeader.XP = 500 * ::Hardened.Global.FactionExperience.Brigands;
	::Const.Tactical.Actor.BanditLeader.ActionPoints = 9;
	::Const.Tactical.Actor.BanditLeader.Hitpoints = 120;
	::Const.Tactical.Actor.BanditLeader.Bravery = 100;
	::Const.Tactical.Actor.BanditLeader.Stamina = 130;
	::Const.Tactical.Actor.BanditLeader.MeleeSkill = 80;
	::Const.Tactical.Actor.BanditLeader.RangedSkill = 45;
	::Const.Tactical.Actor.BanditLeader.MeleeDefense = 20;
	::Const.Tactical.Actor.BanditLeader.RangedDefense = 15;
	::Const.Tactical.Actor.BanditLeader.Initiative = 125;
}

// scripts/entity/tactical/enemies/rf_bandit_baron
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_BanditBaron.XP = 800 * ::Hardened.Global.FactionExperience.Brigands;
	::Const.Tactical.Actor.RF_BanditBaron.ActionPoints = 9;
	::Const.Tactical.Actor.RF_BanditBaron.Hitpoints = 150;
	::Const.Tactical.Actor.RF_BanditBaron.Bravery = 130;
	::Const.Tactical.Actor.RF_BanditBaron.Stamina = 150;
	::Const.Tactical.Actor.RF_BanditBaron.MeleeSkill = 100;
	::Const.Tactical.Actor.RF_BanditBaron.RangedSkill = 45;
	::Const.Tactical.Actor.RF_BanditBaron.MeleeDefense = 30;
	::Const.Tactical.Actor.RF_BanditBaron.RangedDefense = 30;
	::Const.Tactical.Actor.RF_BanditBaron.Initiative = 125;
}
