// scripts/entity/tactical/enemies/skeleton_light
{
	// Mandatory stats
	::Const.Tactical.Actor.SkeletonLight.XP = 210;
	::Const.Tactical.Actor.SkeletonLight.ActionPoints = 9;
	::Const.Tactical.Actor.SkeletonLight.Hitpoints = 45;
	::Const.Tactical.Actor.SkeletonLight.Bravery = 50;
	::Const.Tactical.Actor.SkeletonLight.Stamina = 100;
	::Const.Tactical.Actor.SkeletonLight.MeleeSkill = 60;
	::Const.Tactical.Actor.SkeletonLight.RangedSkill = 0;
	::Const.Tactical.Actor.SkeletonLight.MeleeDefense = 0;
	::Const.Tactical.Actor.SkeletonLight.RangedDefense = 0;
	::Const.Tactical.Actor.SkeletonLight.Initiative = 50;
}

// scripts/entity/tactical/enemies/rf_skeleton_light_elite
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonLightElite.XP = 330;
	::Const.Tactical.Actor.RF_SkeletonLightElite.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonLightElite.Hitpoints = 55;
	::Const.Tactical.Actor.RF_SkeletonLightElite.Bravery = 60;
	::Const.Tactical.Actor.RF_SkeletonLightElite.Stamina = 100;
	::Const.Tactical.Actor.RF_SkeletonLightElite.MeleeSkill = 65;
	::Const.Tactical.Actor.RF_SkeletonLightElite.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonLightElite.MeleeDefense = 5;
	::Const.Tactical.Actor.RF_SkeletonLightElite.RangedDefense = 0;
	::Const.Tactical.Actor.RF_SkeletonLightElite.Initiative = 50;
}

// scripts/entity/tactical/enemies/rf_skeleton_light_elite_polearm
::Const.Tactical.Actor.HD_SkeletonLightElitePolearm <- {
	XP = 330,
	ActionPoints = 9,
	Hitpoints = 55,
	Bravery = 60,
	Stamina = 120,
	MeleeSkill = 70,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 0,
	Initiative = 40,
	Armor = [0, 0],
};

// scripts/entity/tactical/enemies/skeleton_medium
{
	// Mandatory stats
	::Const.Tactical.Actor.SkeletonMedium.XP = 480;
	::Const.Tactical.Actor.SkeletonMedium.ActionPoints = 9;
	::Const.Tactical.Actor.SkeletonMedium.Hitpoints = 65;
	::Const.Tactical.Actor.SkeletonMedium.Bravery = 70;
	::Const.Tactical.Actor.SkeletonMedium.Stamina = 100;
	::Const.Tactical.Actor.SkeletonMedium.MeleeSkill = 70;
	::Const.Tactical.Actor.SkeletonMedium.RangedSkill = 0;
	::Const.Tactical.Actor.SkeletonMedium.MeleeDefense = 10;
	::Const.Tactical.Actor.SkeletonMedium.RangedDefense = 5;
	::Const.Tactical.Actor.SkeletonMedium.Initiative = 60;
}

// scripts/entity/tactical/enemies/skeleton_medium_polearm
::Const.Tactical.Actor.HD_SkeletonMediumPolearm <- {
	XP = 480,
	ActionPoints = 9,
	Hitpoints = 65,
	Bravery = 70,
	Stamina = 100,
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
	::Const.Tactical.Actor.RF_SkeletonDecanus.XP = 600;
	::Const.Tactical.Actor.RF_SkeletonDecanus.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Hitpoints = 65;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Bravery = 80;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Stamina = 100;
	::Const.Tactical.Actor.RF_SkeletonDecanus.MeleeSkill = 70;
	::Const.Tactical.Actor.RF_SkeletonDecanus.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonDecanus.MeleeDefense = 10;
	::Const.Tactical.Actor.RF_SkeletonDecanus.RangedDefense = 5;
	::Const.Tactical.Actor.RF_SkeletonDecanus.Initiative = 75;
}

// scripts/entity/tactical/enemies/rf_skeleton_heavy_lesser
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.XP = 600;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.Hitpoints = 75;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.Bravery = 90;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.Stamina = 100;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.MeleeSkill = 75;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.MeleeDefense = 10;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.RangedDefense = 0;
	::Const.Tactical.Actor.RF_SkeletonHeavyLesser.Initiative = 75;
}

// scripts/entity/tactical/enemies/rf_skeleton_heavy_lesser_bodyguard
::Const.Tactical.Actor.HD_SkeletonHeavyLesserBodyguard <- {
	XP = 600,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 90,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 15,
	RangedDefense = 5,
	Initiative = 25,
	Armor = [0, 0],
};

// scripts/entity/tactical/enemies/vampire
{
	// Mandatory stats
	::Const.Tactical.Actor.Vampire.XP = 600;
	::Const.Tactical.Actor.Vampire.ActionPoints = 9;
	::Const.Tactical.Actor.Vampire.Hitpoints = 225;
	::Const.Tactical.Actor.Vampire.Bravery = 50;
	::Const.Tactical.Actor.Vampire.Stamina = 100;
	::Const.Tactical.Actor.Vampire.MeleeSkill = 85;
	::Const.Tactical.Actor.Vampire.RangedSkill = 0;
	::Const.Tactical.Actor.Vampire.MeleeDefense = 5;
	::Const.Tactical.Actor.Vampire.RangedDefense = 5;
	::Const.Tactical.Actor.Vampire.Initiative = 130;
}

// scripts/entity/tactical/enemies/rf_skeleton_medium_elite
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonMediumElite.XP = 675;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Hitpoints = 75;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Bravery = 80;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Stamina = 100;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.MeleeSkill = 75;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.MeleeDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.RangedDefense = 10;
	::Const.Tactical.Actor.RF_SkeletonMediumElite.Initiative = 60;
}

// scripts/entity/tactical/enemies/rf_skeleton_medium_elite_polearm
::Const.Tactical.Actor.HD_SkeletonMediumElitePolearm <- {
	XP = 675,
	ActionPoints = 9,
	Hitpoints = 75,
	Bravery = 80,
	Stamina = 100,
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
	::Const.Tactical.Actor.SkeletonPriest.XP = 750;
	::Const.Tactical.Actor.SkeletonPriest.ActionPoints = 9;
	::Const.Tactical.Actor.SkeletonPriest.Hitpoints = 65;
	::Const.Tactical.Actor.SkeletonPriest.Bravery = 130;
	::Const.Tactical.Actor.SkeletonPriest.Stamina = 100;
	::Const.Tactical.Actor.SkeletonPriest.MeleeSkill = 40;
	::Const.Tactical.Actor.SkeletonPriest.RangedSkill = 0;
	::Const.Tactical.Actor.SkeletonPriest.MeleeDefense = 0;
	::Const.Tactical.Actor.SkeletonPriest.RangedDefense = 5;
	::Const.Tactical.Actor.SkeletonPriest.Initiative = 10;
}

// scripts/entity/tactical/enemies/skeleton_heavy
{
	// Mandatory stats
	::Const.Tactical.Actor.SkeletonHeavy.XP = 900;
	::Const.Tactical.Actor.SkeletonHeavy.ActionPoints = 9;
	::Const.Tactical.Actor.SkeletonHeavy.Hitpoints = 90;
	::Const.Tactical.Actor.SkeletonHeavy.Bravery = 100;
	::Const.Tactical.Actor.SkeletonHeavy.Stamina = 100;
	::Const.Tactical.Actor.SkeletonHeavy.MeleeSkill = 90;
	::Const.Tactical.Actor.SkeletonHeavy.RangedSkill = 0;
	::Const.Tactical.Actor.SkeletonHeavy.MeleeDefense = 20;
	::Const.Tactical.Actor.SkeletonHeavy.RangedDefense = 0;
	::Const.Tactical.Actor.SkeletonHeavy.Initiative = 75;
}

// scripts/entity/tactical/enemies/rf_skeleton_centurion
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_SkeletonCenturion.XP = 900;
	::Const.Tactical.Actor.RF_SkeletonCenturion.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Hitpoints = 75;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Bravery = 90;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Stamina = 100;
	::Const.Tactical.Actor.RF_SkeletonCenturion.MeleeSkill = 75;
	::Const.Tactical.Actor.RF_SkeletonCenturion.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonCenturion.MeleeDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonCenturion.RangedDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonCenturion.Initiative = 100;
}

// scripts/entity/tactical/enemies/skeleton_heavy_bodyguard
::Const.Tactical.Actor.HD_SkeletonHeavyBodyguard <- {
	XP = 900,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 100,
	Stamina = 100,
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
	::Const.Tactical.Actor.RF_SkeletonLegatus.XP = 1200;
	::Const.Tactical.Actor.RF_SkeletonLegatus.ActionPoints = 9;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Hitpoints = 85;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Bravery = 100;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Stamina = 100;
	::Const.Tactical.Actor.RF_SkeletonLegatus.MeleeSkill = 85;
	::Const.Tactical.Actor.RF_SkeletonLegatus.RangedSkill = 0;
	::Const.Tactical.Actor.RF_SkeletonLegatus.MeleeDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonLegatus.RangedDefense = 20;
	::Const.Tactical.Actor.RF_SkeletonLegatus.Initiative = 80;
}

// scripts/entity/tactical/enemies/rf_vampire_lord
{
	// Mandatory stats
	::Const.Tactical.Actor.RF_VampireLord.XP = 1350;
	::Const.Tactical.Actor.RF_VampireLord.ActionPoints = 9;
	::Const.Tactical.Actor.RF_VampireLord.Hitpoints = 350;
	::Const.Tactical.Actor.RF_VampireLord.Bravery = 100;
	::Const.Tactical.Actor.RF_VampireLord.Stamina = 100;
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
	::Const.Tactical.Actor.Zombie.XP = 180;
	::Const.Tactical.Actor.Zombie.ActionPoints = 6;
	::Const.Tactical.Actor.Zombie.Hitpoints = 90;
	::Const.Tactical.Actor.Zombie.Bravery = 100;
	::Const.Tactical.Actor.Zombie.Stamina = 100;
	::Const.Tactical.Actor.Zombie.MeleeSkill = 50;
	::Const.Tactical.Actor.Zombie.RangedSkill = 0;
	::Const.Tactical.Actor.Zombie.MeleeDefense = -10;
	::Const.Tactical.Actor.Zombie.RangedDefense = -10;
	::Const.Tactical.Actor.Zombie.Initiative = 50;
}

// scripts/entity/tactical/enemies/zombie_yeoman
// scripts/entity/tactical/enemies/zombie_yeoman_bodyguard
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombieYeoman.XP = 324;
	::Const.Tactical.Actor.ZombieYeoman.ActionPoints = 6;
	::Const.Tactical.Actor.ZombieYeoman.Hitpoints = 120;
	::Const.Tactical.Actor.ZombieYeoman.Bravery = 100;
	::Const.Tactical.Actor.ZombieYeoman.Stamina = 100;
	::Const.Tactical.Actor.ZombieYeoman.MeleeSkill = 60;
	::Const.Tactical.Actor.ZombieYeoman.RangedSkill = 0;
	::Const.Tactical.Actor.ZombieYeoman.MeleeDefense = -5;
	::Const.Tactical.Actor.ZombieYeoman.RangedDefense = -5;
	::Const.Tactical.Actor.ZombieYeoman.Initiative = 50;
}

// scripts/entity/tactical/enemies/zombie_nomad
// scripts/entity/tactical/enemies/zombie_nomad_bodyguard
::Const.Tactical.Actor.HD_ZombieNomad <- {
	XP = 360,
	ActionPoints = 6,
	Hitpoints = 120,
	Bravery = 100,
	Stamina = 100,
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
	::Const.Tactical.Actor.Ghost.XP = 450;
	::Const.Tactical.Actor.Ghost.ActionPoints = 9;
	::Const.Tactical.Actor.Ghost.Hitpoints = 1;
	::Const.Tactical.Actor.Ghost.Bravery = 130;
	::Const.Tactical.Actor.Ghost.Stamina = 100;
	::Const.Tactical.Actor.Ghost.MeleeSkill = 65;
	::Const.Tactical.Actor.Ghost.RangedSkill = 0;
	::Const.Tactical.Actor.Ghost.MeleeDefense = 30;
	::Const.Tactical.Actor.Ghost.RangedDefense = 999;
	::Const.Tactical.Actor.Ghost.Initiative = 100;
}

// scripts/entity/tactical/enemies/zombie_knight
// scripts/entity/tactical/enemies/zombie_knight_bodyguard
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombieKnight.XP = 540;
	::Const.Tactical.Actor.ZombieKnight.ActionPoints = 7;
	::Const.Tactical.Actor.ZombieKnight.Hitpoints = 150;
	::Const.Tactical.Actor.ZombieKnight.Bravery = 100;
	::Const.Tactical.Actor.ZombieKnight.Stamina = 100;
	::Const.Tactical.Actor.ZombieKnight.MeleeSkill = 70;
	::Const.Tactical.Actor.ZombieKnight.RangedSkill = 0;
	::Const.Tactical.Actor.ZombieKnight.MeleeDefense = 0;
	::Const.Tactical.Actor.ZombieKnight.RangedDefense = 0;
	::Const.Tactical.Actor.ZombieKnight.Initiative = 60;
}

// scripts/entity/tactical/enemies/necromancer
{
	// Mandatory stats
	::Const.Tactical.Actor.Necromancer.XP = 810;
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
	::Const.Tactical.Actor.ZombieBetrayer.XP = 900;
	::Const.Tactical.Actor.ZombieBetrayer.ActionPoints = 8;
	::Const.Tactical.Actor.ZombieBetrayer.Hitpoints = 200;
	::Const.Tactical.Actor.ZombieBetrayer.Bravery = 100;
	::Const.Tactical.Actor.ZombieBetrayer.Stamina = 100;
	::Const.Tactical.Actor.ZombieBetrayer.MeleeSkill = 80;
	::Const.Tactical.Actor.ZombieBetrayer.RangedSkill = 0;
	::Const.Tactical.Actor.ZombieBetrayer.MeleeDefense = 5;
	::Const.Tactical.Actor.ZombieBetrayer.RangedDefense = 5;
	::Const.Tactical.Actor.ZombieBetrayer.Initiative = 70;
}

// scripts/entity/tactical/enemies/zombie_boss
{
	// Mandatory stats
	::Const.Tactical.Actor.ZombieBoss.XP = 1620;			// Vanilla: 500
	::Const.Tactical.Actor.ZombieBoss.ActionPoints = 7;		// Vanilla: 7
	::Const.Tactical.Actor.ZombieBoss.Hitpoints = 300;		// Vanilla: 500
	::Const.Tactical.Actor.ZombieBoss.Bravery = 110;		// Vanilla: 110
	::Const.Tactical.Actor.ZombieBoss.Stamina = 100;		// Vanilla: 100
	::Const.Tactical.Actor.ZombieBoss.MeleeSkill = 95;		// Vanilla: 95
	::Const.Tactical.Actor.ZombieBoss.RangedSkill = 0;		// Vanilla: 0
	::Const.Tactical.Actor.ZombieBoss.MeleeDefense = 25;	// Vanilla: 25
	::Const.Tactical.Actor.ZombieBoss.RangedDefense = 0;	// Vanilla: 0
	::Const.Tactical.Actor.ZombieBoss.Initiative = 80;		// Vanilla: 75

	::Const.Tactical.Actor.ZombieBoss.Armor[0] = 400;		// Vanilla: 400
	::Const.Tactical.Actor.ZombieBoss.Armor[1] = 250;		// Vanilla: 250
}
