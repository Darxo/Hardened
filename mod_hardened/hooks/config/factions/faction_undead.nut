{	// Elite
	// scripts/entity/tactical/enemies/skeleton_heavy
	::Reforged.Entities.editEntity("SkeletonHeavy",
		{
			Cost = 40,
			Strength = 40, 	// Reforged: 35; Vanilla: 30
			Variant = 0,	// Reforged: 0; Vanilla: 1
		},
		{
			XP = 400 * ::Hardened.Global.FactionExperience.Skeletons, 	// Reforged: 350
			Hitpoints = 75, // Reforged: 75
			Bravery = 90, // Reforged: 90
			Stamina = 200, // Reforged: 100
			MeleeSkill = 75, // Reforged: 75
			RangedSkill = 0, // Reforged: 0
			MeleeDefense = 10,	// Reforged: 10
			RangedDefense = 0, // Reforged: 0
			Initiative = 75,	// Reforged: 75
		}
	);

	// scripts/entity/tactical/enemies/rf_bandit_pillager
	::Reforged.Entities.editEntity("SkeletonHeavyBodyguard",
		{
			Cost = 40,			// Vanilla: 30
			Strength = 40,		// Vanilla: 30
		}
	);

	// We dont need to adjust the troop

	// scripts/entity/tactical/enemies/rf_bandit_pillager
	::Reforged.Entities.editEntity("RF_SkeletonHeavyElite",
		{
			Cost = 60, 		// Reforged: 45
			Strength = 60, 	// Reforged: 45
			Variant = 2,	// Reforged: 1
		},
		{
			XP = 600 * ::Hardened.Global.FactionExperience.Skeletons, // Reforged: 450
			Hitpoints = 90, // Reforged: 90
			Bravery = 100, // Reforged: 100
			Stamina = 200, // Reforged: 100
			MeleeSkill = 90, // Reforged: 80
			RangedSkill = 55, // Reforged: 0
			MeleeDefense = 20,	// Reforged: 15
			RangedDefense = 0, // Reforged: 0
			Initiative = 75,	// Reforged: 75
		}
	);

	// Same as what Reforged does
	::Reforged.Entities.addTroop(
		"RF_SkeletonHeavyEliteBodyguard",
		::MSU.Table.merge(clone ::Const.World.Spawn.Troops.RF_SkeletonHeavyElite, {
			Variant = 0,
			Row = 2,
			Script = "scripts/entity/tactical/enemies/rf_skeleton_heavy_elite_bodyguard"
		})
	);
}

{	// Ghosts
	// scripts/entity/tactical/enemies/rf_banshee
	::Reforged.Entities.editEntity("RF_Banshee",
		{
			Strength = 80,	// Reforged: 50;
			Cost = 80,		// Reforged: 50;
		},
		{
			XP = 800 * ::Hardened.Global.FactionExperience.Zombies, // Reforged: 550
			Hitpoints = 64, // Reforged: 1
			Bravery = 100, // Reforged: 100
			Stamina = 100, // Reforged: 100
			MeleeSkill = 90, // Reforged: 80
			RangedSkill = 0, // Reforged: 0
			MeleeDefense = 30,	// Reforged: 30
			RangedDefense = 999, // Reforged: 999
			Initiative = 100,	// Reforged: 100
		}
	);
}

{	// Flank
	// scripts/entity/tactical/enemies/rf_hollenhund
	::Reforged.Entities.editEntity("RF_Hollenhund",
		{
			Strength = 50,	// Reforged: 40;
			Cost = 50,		// Reforged: 20;
		},
		{
			XP = 500 * ::Hardened.Global.FactionExperience.Zombies, // Reforged: 400
			ActionPoints = 12,	// Reforged: 12
			Hitpoints = 150, // Reforged: 150
			Bravery = 90, // Reforged: 90
			Stamina = 100, // Reforged: 100
			MeleeSkill = 80, // Reforged: 80
			RangedSkill = 0, // Reforged: 0
			MeleeDefense = 30,	// Reforged: 30
			RangedDefense = 30, // Reforged: 50
			Initiative = 110,	// Reforged: 110
		}
	);
}

{	// Zombie Orcs
	// scripts/entity/tactical/enemies/rf_zombie_orc_young
	::Reforged.Entities.editEntity("RF_ZombieOrcYoung",
		{
			Strength = 20,	// Reforged: 14;
			Cost = 20,		// Reforged: 12;
		},
		{
			XP = 200 * ::Hardened.Global.FactionExperience.Zombies, // Reforged: 200
			ActionPoints = 7,	// Reforged: 6
			Hitpoints = 200, // Reforged: 200
			Bravery = 100, // Reforged: 100
			Stamina = 200, // Reforged: 100
			MeleeSkill = 55, // Reforged: 50
			RangedSkill = 0, // Reforged: 0
			MeleeDefense = -10,	// Reforged: -10
			RangedDefense = -10, // Reforged: -10
			Initiative = 60,	// Reforged: 60
		}
	);

	// scripts/entity/tactical/enemies/rf_zombie_orc_warrior
	::Reforged.Entities.editEntity("RF_ZombieOrcWarrior",
		{
			Strength = 50,	// Reforged: 28;
			Cost = 50,		// Reforged: 25;
		},
		{
			XP = 500 * ::Hardened.Global.FactionExperience.Zombies, // Reforged: 350
			ActionPoints = 7,	// Reforged: 7
			Hitpoints = 300, // Reforged: 300
			Bravery = 90, // Reforged: 90
			Stamina = 200, // Reforged: 100
			MeleeSkill = 70, // Reforged: 60
			RangedSkill = 0, // Reforged: 0
			MeleeDefense = -15,	// Reforged: -15
			RangedDefense = -15, // Reforged: -15
			Initiative = 60,	// Reforged: 60
		}
	);

	// scripts/entity/tactical/enemies/rf_zombie_orc_berserker
	::Reforged.Entities.editEntity("RF_ZombieOrcBerserker",
		{
			Strength = 40,	// Reforged: 25;
			Cost = 40,		// Reforged: 20;
		},
		{
			XP = 400 * ::Hardened.Global.FactionExperience.Zombies, // Reforged: 300
			ActionPoints = 7,	// Reforged: 7
			Hitpoints = 350, // Reforged: 350
			Bravery = 90, // Reforged: 90
			Stamina = 200, // Reforged: 100
			MeleeSkill = 70, // Reforged: 60
			RangedSkill = 0, // Reforged: 0
			MeleeDefense = 0,	// Reforged: 0
			RangedDefense = -5, // Reforged: -5
			Initiative = 60,	// Reforged: 60
		}
	);

	// scripts/entity/tactical/enemies/rf_zombie_orc_warlord
	::Reforged.Entities.editEntity("RF_ZombieOrcWarlord",
		{
			Strength = 80,	// Reforged: 36;
			Cost = 80,		// Reforged: 34;
		},
		{
			XP = 800 * ::Hardened.Global.FactionExperience.Zombies, // Reforged: 450
			ActionPoints = 7,	// Reforged: 7
			Hitpoints = 600, // Reforged: 600
			Bravery = 130, // Reforged: 130
			Stamina = 200, // Reforged: 100
			MeleeSkill = 80, // Reforged: 70
			RangedSkill = -15, // Reforged: -15
			MeleeDefense = -15,	// Reforged: -15
			RangedDefense = -5, // Reforged: -5
			Initiative = 60,	// Reforged: 60
		}
	);
}

{	// Draugr
	// scripts/entity/tactical/enemies/rf_draugr_thrall
	::Reforged.Entities.editEntity("RF_DraugrThrall",
		{
			Strength = 25,	// Reforged: 25;
			Cost = 25,		// Reforged: 18;
		},
		{
			XP = 200 * ::Hardened.Global.FactionExperience.Draugr, // Reforged: 200
		}
	);

	// scripts/entity/tactical/enemies/rf_draugr_warrior
	::Reforged.Entities.editEntity("RF_DraugrWarrior",
		{
			Strength = 40,	// Reforged: 35;
			Cost = 40,		// Reforged: 35;
		},
		{
			XP = 400 * ::Hardened.Global.FactionExperience.Draugr, 	// Reforged: 350
		}
	);

	// scripts/entity/tactical/enemies/rf_draugr_huskarl
	::Reforged.Entities.editEntity("RF_DraugrHuskarl",
		{
			Strength = 55,	// Reforged: 45;
			Cost = 55,		// Reforged: 45;
		},
		{
			XP = 550 * ::Hardened.Global.FactionExperience.Draugr, 	// Reforged: 450
		}
	);

	// scripts/entity/tactical/enemies/rf_draugr_hero
	::Reforged.Entities.editEntity("RF_DraugrHero",
		{
			Strength = 80,	// Reforged: 60;
			Cost = 80,		// Reforged: 60;
		},
		{
			XP = 800 * ::Hardened.Global.FactionExperience.Draugr, 	// Reforged: 650
		}
	);

	// scripts/entity/tactical/enemies/rf_draugr_shaman
	::Reforged.Entities.editEntity("RF_DraugrShaman",
		{
			Strength = 100,	// Reforged: 60;
			Cost = 100,		// Reforged: 60;
		},
		{
			XP = 1000 * ::Hardened.Global.FactionExperience.Draugr, 	// Reforged: 500
		}
	);
}

// scripts/entity/tactical/enemies/skeleton_light
{
	// Mandatory stats
	::Const.Tactical.Actor.SkeletonLight.XP = 160 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.SkeletonLight.ActionPoints = 9;
	::Const.Tactical.Actor.SkeletonLight.Hitpoints = 55;
	::Const.Tactical.Actor.SkeletonLight.Bravery = 50;
	::Const.Tactical.Actor.SkeletonLight.Stamina = 200;
	::Const.Tactical.Actor.SkeletonLight.MeleeSkill = 65;
	::Const.Tactical.Actor.SkeletonLight.RangedSkill = 0;
	::Const.Tactical.Actor.SkeletonLight.MeleeDefense = 5;
	::Const.Tactical.Actor.SkeletonLight.RangedDefense = 0;
	::Const.Tactical.Actor.SkeletonLight.Initiative = 50;
}

// scripts/entity/tactical/enemies/skeleton_medium
{
	// Mandatory stats
	::Const.Tactical.Actor.SkeletonMedium.XP = 280 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.SkeletonMedium.ActionPoints = 9;
	::Const.Tactical.Actor.SkeletonMedium.Hitpoints = 65;
	::Const.Tactical.Actor.SkeletonMedium.Bravery = 70;
	::Const.Tactical.Actor.SkeletonMedium.Stamina = 200;
	::Const.Tactical.Actor.SkeletonMedium.MeleeSkill = 70;
	::Const.Tactical.Actor.SkeletonMedium.RangedSkill = 0;
	::Const.Tactical.Actor.SkeletonMedium.MeleeDefense = 10;
	::Const.Tactical.Actor.SkeletonMedium.RangedDefense = 5;
	::Const.Tactical.Actor.SkeletonMedium.Initiative = 60;
}

// scripts/entity/tactical/enemies/skeleton_medium_polearm
::Const.Tactical.Actor.HD_SkeletonMediumPolearm <- {
	XP = 320 * ::Hardened.Global.FactionExperience.Skeletons,
	ActionPoints = 9,
	Hitpoints = 65,
	Bravery = 70,
	Stamina = 200,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 0,
	Initiative = 50,
	Armor = [0, 0],
};

// scripts/entity/tactical/enemies/rf_skeleton_decanus
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonDecanus.XP = 400 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.RF_SkeletonDecanus.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Hitpoints = 70;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Bravery = 80;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Stamina = 200;
	::Const.Tactical.Actor.RF_SkeletonDecanus.MeleeSkill = 70;
	::Const.Tactical.Actor.RF_SkeletonDecanus.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonDecanus.MeleeDefense = 0;
	::Const.Tactical.Actor.RF_SkeletonDecanus.RangedDefense = 0;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Initiative = 75;
}

// scripts/entity/tactical/enemies/vampire
{
	// Mandatory stats
	::Const.Tactical.Actor.Vampire.XP = 500 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.Vampire.ActionPoints = 9;
	::Const.Tactical.Actor.Vampire.Hitpoints = 225;
	::Const.Tactical.Actor.Vampire.Bravery = 50;
	::Const.Tactical.Actor.Vampire.Stamina = 200;
	::Const.Tactical.Actor.Vampire.MeleeSkill = 85;
	::Const.Tactical.Actor.Vampire.RangedSkill = 0;
	::Const.Tactical.Actor.Vampire.MeleeDefense = 5;
	::Const.Tactical.Actor.Vampire.RangedDefense = 5;
	::Const.Tactical.Actor.Vampire.Initiative = 130;
}

// scripts/entity/tactical/enemies/rf_skeleton_medium_elite
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonMediumElite.XP = 450 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Hitpoints = 75;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Bravery = 80;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Stamina = 200;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.MeleeSkill = 75;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.MeleeDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.RangedDefense = 10;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Initiative = 60;
}

// scripts/entity/tactical/enemies/rf_skeleton_medium_elite_polearm
::Const.Tactical.Actor.HD_SkeletonMediumElitePolearm <- {
	XP = 450 * ::Hardened.Global.FactionExperience.Skeletons,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 80,
	Stamina = 200,
	MeleeSkill = 85,
	RangedSkill = 0,
	MeleeDefense = 15,
	RangedDefense = 0,
	Initiative = 50,
	Armor = [0, 0],
};

// scripts/entity/tactical/enemies/skeleton_priest
{
	// Mandatory stats
	::Const.Tactical.Actor.SkeletonPriest.XP = 500 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.SkeletonPriest.ActionPoints = 9;
	::Const.Tactical.Actor.SkeletonPriest.Hitpoints = 65;
	::Const.Tactical.Actor.SkeletonPriest.Bravery = 130;
	::Const.Tactical.Actor.SkeletonPriest.Stamina = 200;
	::Const.Tactical.Actor.SkeletonPriest.MeleeSkill = 40;
	::Const.Tactical.Actor.SkeletonPriest.RangedSkill = 0;
	::Const.Tactical.Actor.SkeletonPriest.MeleeDefense = 0;
	::Const.Tactical.Actor.SkeletonPriest.RangedDefense = 5;
	::Const.Tactical.Actor.SkeletonPriest.Initiative = 10;
}

// scripts/entity/tactical/enemies/rf_skeleton_centurion
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonCenturion.XP = 600 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.RF_SkeletonCenturion.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Hitpoints = 80;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Bravery = 90;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Stamina = 200;
	::Const.Tactical.Actor.RF_SkeletonCenturion.MeleeSkill = 80;
	::Const.Tactical.Actor.RF_SkeletonCenturion.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonCenturion.MeleeDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonCenturion.RangedDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Initiative = 120;
}

// scripts/entity/tactical/enemies/skeleton_heavy_bodyguard
::Const.Tactical.Actor.HD_SkeletonHeavyBodyguard <- {
	XP = 600 * ::Hardened.Global.FactionExperience.Skeletons,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 100,
	Stamina = 200,
	MeleeSkill = 90,
	RangedSkill = 0,
	MeleeDefense = 30,
	RangedDefense = 10,
	Initiative = 25,
	Armor = [0, 0],
};

// scripts/entity/tactical/enemies/rf_skeleton_legatus
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonLegatus.XP = 800 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.RF_SkeletonLegatus.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Hitpoints = 90;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Bravery = 100;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Stamina = 200;
	::Const.Tactical.Actor.RF_SkeletonLegatus.MeleeSkill = 85;
	::Const.Tactical.Actor.RF_SkeletonLegatus.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonLegatus.MeleeDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonLegatus.RangedDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Initiative = 80;
}

// scripts/entity/tactical/enemies/rf_vampire_lord
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_VampireLord.XP = 1000 * ::Hardened.Global.FactionExperience.Skeletons;
	::Const.Tactical.Actor.RF_VampireLord.ActionPoints = 9;
	::Const.Tactical.Actor.RF_VampireLord.Hitpoints = 350;
	::Const.Tactical.Actor.RF_VampireLord.Bravery = 100;
	::Const.Tactical.Actor.RF_VampireLord.Stamina = 200;
	::Const.Tactical.Actor.RF_VampireLord.MeleeSkill = 85;
	::Const.Tactical.Actor.RF_VampireLord.RangedSkill = 0;
	::Const.Tactical.Actor.RF_VampireLord.MeleeDefense = 20;
	::Const.Tactical.Actor.RF_VampireLord.RangedDefense = 20;
	::Const.Tactical.Actor.RF_VampireLord.Initiative = 130;
}

// scripts/entity/tactical/enemies/zombie
// scripts/entity/tactical/enemies/zombie_bodyguard
{
	// Mandatory stats
	::Const.Tactical.Actor.Zombie.XP = 100 * ::Hardened.Global.FactionExperience.Zombies;		// Vanilla: 100
	::Const.Tactical.Actor.Zombie.ActionPoints = 6;		// Vanilla 6
	::Const.Tactical.Actor.Zombie.Hitpoints = 90;		// Vanilla: 100
	::Const.Tactical.Actor.Zombie.Bravery = 100;		// Vanilla: 100
	::Const.Tactical.Actor.Zombie.Stamina = 200;		// Vanilla: 100
	::Const.Tactical.Actor.Zombie.MeleeSkill = 50;		// Vanilla: 45
	::Const.Tactical.Actor.Zombie.RangedSkill = 0;		// Vanilla: 5
	::Const.Tactical.Actor.Zombie.MeleeDefense = -10;	// Vanilla: -5
	::Const.Tactical.Actor.Zombie.RangedDefense = -10;	// Vanilla: -5
	::Const.Tactical.Actor.Zombie.Initiative = 50;		// Vanilla: 45
}

// scripts/entity/tactical/enemies/zombie_player
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombiePlayer.XP = 100 * ::Hardened.Global.FactionExperience.Zombies;				// Vanilla: 150
	::Const.Tactical.Actor.ZombiePlayer.ActionPoints = 6;		// Vanilla 6
	::Const.Tactical.Actor.ZombiePlayer.Hitpoints = 120;		// Vanilla: 130
	::Const.Tactical.Actor.ZombiePlayer.Bravery = 100;			// Vanilla: 100
	::Const.Tactical.Actor.ZombiePlayer.Stamina = 200;			// Vanilla: 100
	::Const.Tactical.Actor.ZombiePlayer.MeleeSkill = 50;		// Vanilla: 50
	::Const.Tactical.Actor.ZombiePlayer.RangedSkill = 0;		// Vanilla: 0
	::Const.Tactical.Actor.ZombiePlayer.MeleeDefense = 5;		// Vanilla: 5
	::Const.Tactical.Actor.ZombiePlayer.RangedDefense = 5;		// Vanilla: 5
	::Const.Tactical.Actor.ZombiePlayer.Initiative = 50;		// Vanilla: 50
}

// scripts/entity/tactical/enemies/zombie_yeoman
// scripts/entity/tactical/enemies/zombie_yeoman_bodyguard
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombieYeoman.XP = 180 * ::Hardened.Global.FactionExperience.Zombies;;				// Vanilla: 150
	::Const.Tactical.Actor.ZombieYeoman.ActionPoints = 6;		// Vanilla: 6
	::Const.Tactical.Actor.ZombieYeoman.Hitpoints = 120;		// Vanilla: 130
	::Const.Tactical.Actor.ZombieYeoman.Bravery = 100;			// Vanilla: 100
	::Const.Tactical.Actor.ZombieYeoman.Stamina = 200;			// Vanilla: 100
	::Const.Tactical.Actor.ZombieYeoman.MeleeSkill = 60;		// Vanilla: 50
	::Const.Tactical.Actor.ZombieYeoman.RangedSkill = 0;		// Vanilla: 0
	::Const.Tactical.Actor.ZombieYeoman.MeleeDefense = -5;		// Vanilla: -5
	::Const.Tactical.Actor.ZombieYeoman.RangedDefense = -5;		// Vanilla: -5
	::Const.Tactical.Actor.ZombieYeoman.Initiative = 50;		// Vanilla: 45
}

// scripts/entity/tactical/enemies/zombie_nomad
// scripts/entity/tactical/enemies/zombie_nomad_bodyguard
::Const.Tactical.Actor.HD_ZombieNomad <- {
	XP = 200 * ::Hardened.Global.FactionExperience.Zombies,
	ActionPoints = 6,
	Hitpoints = 120,
	Bravery = 100,
	Stamina = 200,
	MeleeSkill = 65,
	RangedSkill = 0,
	MeleeDefense = -5,
	RangedDefense = -5,
	Initiative = 60,
	Armor = [0, 0],
};

// scripts/entity/tactical/enemies/ghost
{
	// Mandatory stats
	::Const.Tactical.Actor.Ghost.XP = 250 * ::Hardened.Global.FactionExperience.Zombies;
	::Const.Tactical.Actor.Ghost.ActionPoints = 9;
	::Const.Tactical.Actor.Ghost.Hitpoints = 1;
	::Const.Tactical.Actor.Ghost.Bravery = 130;
	::Const.Tactical.Actor.Ghost.Stamina = 200;
	::Const.Tactical.Actor.Ghost.MeleeSkill = 70;		// Vanilla: 65
	::Const.Tactical.Actor.Ghost.RangedSkill = 0;
	::Const.Tactical.Actor.Ghost.MeleeDefense = 30;
	::Const.Tactical.Actor.Ghost.RangedDefense = 999;
	::Const.Tactical.Actor.Ghost.Initiative = 100;
}

// scripts/entity/tactical/enemies/zombie_knight
// scripts/entity/tactical/enemies/zombie_knight_bodyguard
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombieKnight.XP = 300 * ::Hardened.Global.FactionExperience.Zombies;		// Vanilla: 250
	::Const.Tactical.Actor.ZombieKnight.ActionPoints = 7;		// Vanilla: 7
	::Const.Tactical.Actor.ZombieKnight.Hitpoints = 150;		// Vanilla: 180
	::Const.Tactical.Actor.ZombieKnight.Bravery = 100;			// Vanilla: 130
	::Const.Tactical.Actor.ZombieKnight.Stamina = 200;			// Vanilla: 100
	::Const.Tactical.Actor.ZombieKnight.MeleeSkill = 70;		// Vanilla: 60
	::Const.Tactical.Actor.ZombieKnight.RangedSkill = 0;		// Vanilla: 0
	::Const.Tactical.Actor.ZombieKnight.MeleeDefense = 0;		// Vanilla: 5
	::Const.Tactical.Actor.ZombieKnight.RangedDefense = 0;		// Vanilla: 0
	::Const.Tactical.Actor.ZombieKnight.Initiative = 60;		// Vanilla: 60
}

// scripts/entity/tactical/enemies/necromancer
{
	// Mandatory stats
	::Const.Tactical.Actor.Necromancer.XP = 450 * ::Hardened.Global.FactionExperience.Zombies;
	::Const.Tactical.Actor.Necromancer.ActionPoints = 7;
	::Const.Tactical.Actor.Necromancer.Hitpoints = 50;
	::Const.Tactical.Actor.Necromancer.Bravery = 120;
	::Const.Tactical.Actor.Necromancer.Stamina = 90;
	::Const.Tactical.Actor.Necromancer.MeleeSkill = 50;
	::Const.Tactical.Actor.Necromancer.RangedSkill = 0;
	::Const.Tactical.Actor.Necromancer.MeleeDefense = 5;
	::Const.Tactical.Actor.Necromancer.RangedDefense = 10;
	::Const.Tactical.Actor.Necromancer.Initiative = 90;
	::Const.Tactical.Actor.Necromancer.Armor[0] = 0;

	// Optional Stats
	::Const.Tactical.Actor.Necromancer.Vision <- 8;
}

// scripts/entity/tactical/enemies/zombie_betrayer
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombieBetrayer.XP = 500 * ::Hardened.Global.FactionExperience.Zombies;		// Vanilla: 350
	::Const.Tactical.Actor.ZombieBetrayer.Bravery = 100;		// Vanilla: 110
	::Const.Tactical.Actor.ZombieBetrayer.Stamina = 200;		// Vanilla: 100
	::Const.Tactical.Actor.ZombieBetrayer.MeleeDefense = 20;	// Vanilla: 5
	::Const.Tactical.Actor.ZombieBetrayer.RangedDefense = 20;	// Vanilla: 0
	::Const.Tactical.Actor.ZombieBetrayer.Initiative = 70;		// Vanilla: 60
}

// scripts/entity/tactical/enemies/zombie_boss
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombieBoss.XP = 900 * ::Hardened.Global.FactionExperience.Zombies;	// Vanilla: 500
	::Const.Tactical.Actor.ZombieBoss.ActionPoints = 7;		// Vanilla: 7
	::Const.Tactical.Actor.ZombieBoss.Hitpoints = 300;		// Vanilla: 500
	::Const.Tactical.Actor.ZombieBoss.Bravery = 110;		// Vanilla: 110
	::Const.Tactical.Actor.ZombieBoss.Stamina = 200;		// Vanilla: 100
	::Const.Tactical.Actor.ZombieBoss.MeleeSkill = 95;		// Vanilla: 95
	::Const.Tactical.Actor.ZombieBoss.RangedSkill = 0;		// Vanilla: 0
	::Const.Tactical.Actor.ZombieBoss.MeleeDefense = 25;	// Vanilla: 25
	::Const.Tactical.Actor.ZombieBoss.RangedDefense = 0;	// Vanilla: 0
	::Const.Tactical.Actor.ZombieBoss.Initiative = 80;		// Vanilla: 75

	::Const.Tactical.Actor.ZombieBoss.Armor[0] = 400;		// Vanilla: 400
	::Const.Tactical.Actor.ZombieBoss.Armor[1] = 250;		// Vanilla: 250
}
