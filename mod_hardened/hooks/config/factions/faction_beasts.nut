{	// Canines
	// scripts/entity/tactical/enemies/direwolf
	::Reforged.Entities.editEntity("Direwolf",	// Direwolf
		{
			Cost = 20,
			Strength = 20,
		},
		{
			XP = 200 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 200
			ActionPoints = 10,	// Vanilla: 12
			Hitpoints = 130,
			Bravery = 60,		// Vanilla: 50
			Stamina = 150,		// Vanilla: 180
			MeleeSkill = 70,	// Vanilla: 60
			RangedSkill = 0,
			MeleeDefense = 15,	// Vanilla: 10
			RangedDefense = 15,	// Vanilla: 10
			Initiative = 150,
			Reach = 3,
		}
	);

	// scripts/entity/tactical/enemies/direwolf_high
	// scripts/entity/tactical/enemies/direwolf_bodyguard
	::Reforged.Entities.editEntity("FrenziedDirewolf",	// Frenzied Direwolf
		null,
		{
			XP = 400 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 250
			ActionPoints = 12,
			Hitpoints = 150,
			Bravery = 70,
			Stamina = 200,			// Vanilla: 180
			MeleeSkill = 80,		// Vanilla: 65
			RangedSkill = 0,
			MeleeDefense = 25,		// Vanilla: 10
			RangedDefense = 25,		// Vanilla: 10
			Initiative = 150,
			Reach = 3,
		}
	);
	// scripts/entity/tactical/enemies/direwolf_high
	// scripts/entity/tactical/enemies/direwolf_bodyguard
	::Reforged.Entities.editEntity("DirewolfHIGH",	// Frenzied Direwolf
		{
			Cost = 40,
			Strength = 40,
		}
	);

	// scripts/entity/tactical/enemies/hyena
	::Reforged.Entities.editEntity("Hyena",	// Hyena
		{
			Cost = 20,
			Strength = 20,
		},
		{
			XP = 200 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 200
			ActionPoints = 11,		// Vanilla: 14
			Hitpoints = 120,
			Bravery = 60,			// Vanilla: 14
			Stamina = 150,			// Vanilla: 180
			MeleeSkill = 70,		// Vanilla: 60
			RangedSkill = 0,
			MeleeDefense = 10,
			RangedDefense = 10,
			Initiative = 90,
			Reach = 3,
		}
	);

	// scripts/entity/tactical/enemies/hyena_high
	::Reforged.Entities.editEntity("FrenziedHyena",	// Frenzied Hyena
		null,
		{
			XP = 400 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 250
			ActionPoints = 14,
			Hitpoints = 140,
			Bravery = 70,
			Stamina = 200,			// Vanilla: 180
			MeleeSkill = 80,		// Vanilla: 65
			RangedSkill = 0,
			MeleeDefense = 15,		// Vanilla: 10
			RangedDefense = 15,	// Vanilla: 10
			Initiative = 130,
			Reach = 3,
		}
	);
	// scripts/entity/tactical/enemies/hyena_high
	::Reforged.Entities.editEntity("HyenaHIGH",	// Frenzied Hyena
		{
			Cost = 40,
			Strength = 40,
		}
	);
}

{	// Ghouls
	// scripts/entity/tactical/enemies/ghoul_medium
	::Reforged.Entities.editEntity("Ghoul",	// Medium Nachzehrer
		{
			Cost = 25,
			Strength = 25,
		},
		{
			XP = 150 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 125
			ActionPoints = 9,
			Hitpoints = 120,		// Vanilla: 80
			Bravery = 50,
			Stamina = 130,
			MeleeSkill = 60,
			RangedSkill = 0,
			MeleeDefense = 0,		// Vanilla: 10
			RangedDefense = 20,		// Vanilla: 15
			Initiative = 120,		// Vanilla: 125
			Reach = 2,
		}
	);
	// scripts/entity/tactical/enemies/ghoul
	::Reforged.Entities.editEntity("GhoulLOW",	// Small Nachzehrer
		{
			Cost = 15,
			Strength = 15,
		}
	);
	// scripts/entity/tactical/enemies/ghoul_high
	::Reforged.Entities.editEntity("GhoulHIGH",	// Large Nachzehrer
		{
			Cost = 40,
			Strength = 40,
		}
	);

	// scripts/entity/tactical/enemies/ghoul_medium
	{
		// Mandatory stats
		::Const.Tactical.Actor.HD_GhoulMedium <- {
			XP = 250 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 250
			ActionPoints = 9,
			Hitpoints = 240,	// Vanilla: 200
			Bravery = 80,
			Stamina = 130,
			MeleeSkill = 70,
			RangedSkill = 0,
			MeleeDefense = 15,	// Vanilla: 15
			RangedDefense = 15,	// Vanilla: 10
			Initiative = 100,	// Vanilla: 110
			Armor = [0, 0],

			DamageRegularMin = 15,
			DamageRegularMax = 20,
			Reach = 4,
		}
	}

	// scripts/entity/tactical/enemies/ghoul_high
	{
		// Mandatory stats
		::Const.Tactical.Actor.HD_GhoulHigh <- {
			XP = 400 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 375
			ActionPoints = 9,
			Hitpoints = 420,	// Vanilla: 380
			Bravery = 110,
			Stamina = 130,
			MeleeSkill = 80,
			RangedSkill = 0,
			MeleeDefense = 20,	// Vanilla: 20
			RangedDefense = 10,	// Vanilla: 5
			Initiative = 80,	// Vanilla: 95
			Armor = [0, 0],

			DamageRegularMin = 30,
			DamageRegularMax = 40,
			Reach = 6,
		}
	}
}

{	// Sand Golems
	// scripts/entity/tactical/enemies/sand_golem
	::Reforged.Entities.editEntity("SandGolem",	// Sand Golem
		{
			Cost = 12,
			Strength = 12,
		},
		{
			XP = 120 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 150
			ActionPoints = 8,
			Hitpoints = 55,		// Vanilla: 110
			Bravery = 100,			// Vanilla: 999
			Stamina = 400,
			MeleeSkill = 65,
			RangedSkill = 60,
			MeleeDefense = 0,		// Vanilla: -5
			RangedDefense = 0,		// Vanilla: -5
			Initiative = 60,
			Armor = [165, 0],		// Vanilla: 110/110

			// Optional Stats
			DamageRegularMin = 35,
			DamageRegularMax = 45,
			Reach = 2,
		}
	);

	// scripts/entity/tactical/enemies/sand_golem_medium
	{
		// Mandatory stats
		::Const.Tactical.Actor.HD_SandGolemMedium <- {
			XP = 120 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 150
			ActionPoints = 8,
			Hitpoints = 110,	// Vanilla: 220
			Bravery = 100,		// Vanilla: 999
			Stamina = 400,
			MeleeSkill = 75,
			RangedSkill = 75,	// Vanilla: 70
			MeleeDefense = 5,	// Vanilla: 0
			RangedDefense = -5,	// Vanilla: -10
			Initiative = 50,
			Armor = [220, 0],	// Vanilla: 110/110

			// Optional Values
			DamageRegularMin = 60,	// Vanilla: 70
			DamageRegularMax = 80,	// Vanilla: 90
			Reach = 4,
		}
		// scripts/entity/tactical/enemies/sand_golem_medium
		::Reforged.Entities.editEntity("SandGolemMEDIUM",	// Medium Ifrit
			{
				Cost = 36,
				Strength = 36,
			}
		);
	}

	// scripts/entity/tactical/enemies/sand_golem_high
	{
		// Mandatory stats
		::Const.Tactical.Actor.HD_SandGolemHigh <- {
			XP = 120 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 150
			ActionPoints = 8,
			Hitpoints = 220,		// Vanilla: 440
			Bravery = 100,			// Vanilla: 999
			Stamina = 400,
			MeleeSkill = 90,		// Vanilla: 80
			RangedSkill = 90,		// Vanilla: 80
			MeleeDefense = 10,		// Vanilla: 5
			RangedDefense = -10,	// Vanilla: -15
			Initiative = 40,
			Armor = [330, 0],		// Vanilla: 110/110

			// Optional Values
			DamageRegularMin = 80,	// Vanilla: 105
			DamageRegularMax = 100,	// Vanilla: 135
			Reach = 6,
		}
		// scripts/entity/tactical/enemies/sand_golem_high
		::Reforged.Entities.editEntity("SandGolemHIGH",	// Large Ifrit
			{
				Cost = 108,
				Strength = 108,
			}
		);
	}
}

{	// Snakes
	// scripts/entity/tactical/enemies/serpent
	::Reforged.Entities.editEntity("Serpent",	// Serpent
		{
			Cost = 30,
			Strength = 30,
		},
		{
			XP = 300 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 175
			ActionPoints = 9,
			Hitpoints = 130,
			Bravery = 80,		// Vanilla: 100
			Stamina = 110,
			MeleeSkill = 75,		// Vanilla: 65
			RangedSkill = 0,
			MeleeDefense = 20,	// Vanilla: 10
			RangedDefense = 25,
			Initiative = 90,		// Vanilla: 50
			Reach = 3,
		}
	);
}

{	// Schrats
	// scripts/entity/tactical/enemies/schrat
	::Reforged.Entities.editEntity("Schrat",	// Schrat
		{
			Cost = 80,
			Strength = 80,
		},
		{
			XP = 800 * ::Hardened.Global.FactionExperience.Beasts,	// Vanilla: 600
			ActionPoints = 7,
			Hitpoints = 800,		// Vanilla: 600
			Bravery = 200,
			Stamina = 400,
			MeleeSkill = 70,
			RangedSkill = 0,
			MeleeDefense = 10,
			RangedDefense = 0,
			Initiative = 60,
			Reach = 7,
		}
	);
}

{	// Spiders
	// scripts/entity/tactical/enemies/spider
	// scripts/entity/tactical/enemies/spider_bodyguard
	::Reforged.Entities.editEntity("Spider",	// Spider
		{
			Cost = 15,	// Bodyguard uses different cost, see SpiderBodyguard
			Strength = 15,
		},
		{
			XP = 150 * ::Hardened.Global.FactionExperience.Beasts,
			ActionPoints = 11,
			Hitpoints = 60,
			Bravery = 50,
			Stamina = 100,		// Vanilla: 130
			MeleeSkill = 60,
			RangedSkill = 0,
			MeleeDefense = 15,	// Vanilla: 10
			RangedDefense = 25,	// Vanilla: 20
			Initiative = 150,
			Reach = 1,
		}
	);
}

{	// Alps
	// scripts/entity/tactical/enemies/alp
	::Reforged.Entities.editEntity("Alp",	// Alp
		{
			Cost = 25,
			Strength = 25,
			HD_FormationRole = ::Hardened.Deployment.FormationRole.Backline,
		},
		{
			XP = 300 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 300
			ActionPoints = 10,
			Hitpoints = 100,
			Bravery = 90,			// Vanilla: 100
			Stamina = 100,
			MeleeSkill = 0,
			RangedSkill = 0,
			MeleeDefense = 10,
			RangedDefense = 10,
			Initiative = 100,		// Vanilla: 60
			Reach = 7,
		}
	);
}

{	// Hexen
	// scripts/entity/tactical/enemies/hexe
	::Reforged.Entities.editEntity("Hexe",	// Hexe
		{
			Cost = 60,
			Strength = 60,
		},
		{
			XP = 600 * ::Hardened.Global.FactionExperience.Beasts,
			ActionPoints = 9,
			Hitpoints = 70,					// Vanilla: 80
			Bravery = 110,					// Vanilla: 160
			Stamina = 100,					// Vanilla: 160
			MeleeSkill = 0,
			RangedSkill = 0,
			MeleeDefense = 5,
			RangedDefense = 15,				// Vanilla: 5
			Initiative = 100,
			Vision = 8,					// Vanilla: 7
		}
	);
}

{	// Unholds
	// scripts/entity/tactical/enemies/unhold
	// scripts/entity/tactical/enemies/unhold_armored
	::Reforged.Entities.editEntity("Unhold",	// Unhold
		{
			Cost = 80,
			Strength = 80,
		},
		{
			XP = 600 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 400
			ActionPoints = 9,
			Hitpoints = 700,				// Vanilla: 500
			Bravery = 130,
			Stamina = 400,
			MeleeSkill = 80,				// Vanilla: 70
			RangedSkill = 0,
			MeleeDefense = 10,
			RangedDefense = 0,
			Initiative = 70,				// Vanilla: 75
			Armor = [150, 150],				// Vanilla: 0
			Reach = 6,
		}
	);
	// scripts/entity/tactical/enemies/unhold_armored
	::Reforged.Entities.editEntity("BarbarianUnhold",	// Armored Unhold
		{
			Cost = 80,
			Strength = 80,
		}
	);

	// scripts/entity/tactical/enemies/unhold_bog
	::Reforged.Entities.editEntity("UnholdBog",	// Bog Unhold
		{
			Cost = 80,	// Seperate cost entry for BarbarianUnhold
			Strength = 80,
		},
		{
			XP = 700 * ::Hardened.Global.FactionExperience.Beasts,			// Vanilla: 400
			ActionPoints = 9,
			Hitpoints = 700,			// Vanilla: 500
			Bravery = 130,
			Stamina = 400,
			MeleeSkill = 80,			// Vanilla: 70
			RangedSkill = 0,
			MeleeDefense = 10,
			RangedDefense = 15,		// Vanilla: 0
			Initiative = 70,			// Vanilla: 75
			Reach = 6,
		}
	);

	// scripts/entity/tactical/enemies/unhold_frost
	// scripts/entity/tactical/enemies/unhold_frost_armored
	::Reforged.Entities.editEntity("UnholdFrost",	// Frost Unhold
		{
			Cost = 100,
			Strength = 100,
		},
		{
			XP = 800 * ::Hardened.Global.FactionExperience.Beasts,
			ActionPoints = 9,
			Hitpoints = 800,			// Vanilla: 600
			Bravery = 150,
			Stamina = 400,
			MeleeSkill = 85,			// Vanilla: 75
			RangedSkill = 0,
			MeleeDefense = 15,
			RangedDefense = 0,
			Initiative = 80,			// Vanilla: 85
			Armor = [200, 200],			// Vanilla: 90/90
			Reach = 7,
		}
	);
	// scripts/entity/tactical/enemies/unhold_frost_armored
	::Reforged.Entities.editEntity("BarbarianUnholdFrost",	// Armored Frost Unhold
		{
			Cost = 110,
			Strength = 110,
		}
	);
}

{	// Lindwurms
	// scripts/entity/tactical/enemies/lindwurm
	::Reforged.Entities.editEntity("Lindwurm",	// Lindwurm
		{
			Cost = 150,	// Seperate cost entry for BarbarianUnholdFrost
			Strength = 150,
		},
		{
			XP = 1500 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 800
			ActionPoints = 7,
			Hitpoints = 1000,		// Vanilla: 1100 (Shared with Tail)
			Bravery = 180,
			Stamina = 400,
			MeleeSkill = 75,
			RangedSkill = 0,
			MeleeDefense = 20,		// Vanilla: 10, Reforged: 5
			RangedDefense = 10,
			Initiative = 80,
			Reach = 7,
		}
	);

	// scripts/entity/tactical/enemies/lindwurm_tail
	{
		// Mandatory stats
		::Const.Tactical.Actor.HD_LindwurmTail <- {
			XP = 0,				// Vanilla: 800
			ActionPoints = 7,
			Hitpoints = 500,	// Vanilla: 1100 (Shared with Head)
			Bravery = 90,		// Vanilla: 180
			Stamina = 400,
			MeleeSkill = 75,
			RangedSkill = 0,
			MeleeDefense = 30,	// Vanilla: 20
			RangedDefense = 10,
			Initiative = 80,
			Armor = [300, 0],	// Vanilla: 400, 200
			Reach = 6,
		}
	}
}

{	// Legendary
	// scripts/entity/tactical/enemies/trickster_god
	::Reforged.Entities.editEntity("TricksterGod",	// Ijirok
		null,
		{
			XP = 4000 * ::Hardened.Global.FactionExperience.Beasts,		// Vanilla: 1500
			ActionPoints = 9,
			Hitpoints = 2000,		// Vanilla: 2200
			Bravery = 999,
			Stamina = 400,
			MeleeSkill = 90,		// Vanilla: 95
			RangedSkill = 0,
			MeleeDefense = 20,		// Vanilla: 20
			RangedDefense = 15,		// Vanilla: 15
			Initiative = 50,		// Vanilla: 95
			Armor = [600, 600],	// Vanilla: 140, 140
			DamageRegularMin = 80,
			DamageRegularMax = 100,
			Reach = 7,
		}
	);
}
