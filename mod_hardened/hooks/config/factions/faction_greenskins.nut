// scripts/entity/tactical/enemies/goblin_fighter
{
	// Mandatory stats
	::Const.Tactical.Actor.GoblinFighter.XP = 360;
	::Const.Tactical.Actor.GoblinFighter.ActionPoints = 9;
	::Const.Tactical.Actor.GoblinFighter.Hitpoints = 40;
	::Const.Tactical.Actor.GoblinFighter.Bravery = 50;
	::Const.Tactical.Actor.GoblinFighter.Stamina = 100;
	::Const.Tactical.Actor.GoblinFighter.MeleeSkill = 70;
	::Const.Tactical.Actor.GoblinFighter.RangedSkill = 65;
	::Const.Tactical.Actor.GoblinFighter.MeleeDefense = 5;
	::Const.Tactical.Actor.GoblinFighter.RangedDefense = 0;
	::Const.Tactical.Actor.GoblinFighter.Initiative = 130;
}

// scripts/entity/tactical/enemies/goblin_ambusher
{
	// Mandatory stats
	::Const.Tactical.Actor.GoblinAmbusher.XP = 360;
	::Const.Tactical.Actor.GoblinAmbusher.ActionPoints = 9;
	::Const.Tactical.Actor.GoblinAmbusher.Hitpoints = 40;
	::Const.Tactical.Actor.GoblinAmbusher.Bravery = 50;
	::Const.Tactical.Actor.GoblinAmbusher.Stamina = 100;
	::Const.Tactical.Actor.GoblinAmbusher.MeleeSkill = 55;
	::Const.Tactical.Actor.GoblinAmbusher.RangedSkill = 70;
	::Const.Tactical.Actor.GoblinAmbusher.MeleeDefense = 0;
	::Const.Tactical.Actor.GoblinAmbusher.RangedDefense = 20;
	::Const.Tactical.Actor.GoblinAmbusher.Initiative = 140;

	// Optional Stats
	::Const.Tactical.Actor.GoblinAmbusher.Vision <- 8;
}

// scripts/entity/tactical/enemies/goblin_wolfrider
{
	// Mandatory stats
	::Const.Tactical.Actor.GoblinWolfrider.XP = 540;
	::Const.Tactical.Actor.GoblinWolfrider.ActionPoints = 13;
	::Const.Tactical.Actor.GoblinWolfrider.Hitpoints = 60;
	::Const.Tactical.Actor.GoblinWolfrider.Bravery = 70;		// Vanilla: 60
	::Const.Tactical.Actor.GoblinWolfrider.Stamina = 100;		// Vanilla: 150
	::Const.Tactical.Actor.GoblinWolfrider.MeleeSkill = 75;
	::Const.Tactical.Actor.GoblinWolfrider.RangedSkill = 50;
	::Const.Tactical.Actor.GoblinWolfrider.MeleeDefense = 15;
	::Const.Tactical.Actor.GoblinWolfrider.RangedDefense = 25;	// Vanilla: 15
	::Const.Tactical.Actor.GoblinWolfrider.Initiative = 130;
}

// scripts/entity/tactical/enemies/goblin_leader
{
	// Mandatory stats
	::Const.Tactical.Actor.GoblinWolfrider.XP = 900;
	::Const.Tactical.Actor.GoblinLeader.ActionPoints = 9;
	::Const.Tactical.Actor.GoblinLeader.Hitpoints = 70;
	::Const.Tactical.Actor.GoblinLeader.Bravery = 80;
	::Const.Tactical.Actor.GoblinLeader.Stamina = 130;
	::Const.Tactical.Actor.GoblinLeader.MeleeSkill = 75;
	::Const.Tactical.Actor.GoblinLeader.RangedSkill = 80;
	::Const.Tactical.Actor.GoblinLeader.MeleeDefense = 15;
	::Const.Tactical.Actor.GoblinLeader.RangedDefense = 15;
	::Const.Tactical.Actor.GoblinLeader.Initiative = 120;

	// Optional Stats
	::Const.Tactical.Actor.GoblinLeader.Vision <- 8;		// Vanilla: 7
}

// scripts/entity/tactical/enemies/goblin_shaman
{
	// Mandatory stats
	::Const.Tactical.Actor.GoblinShaman.XP = 900;
	::Const.Tactical.Actor.GoblinShaman.ActionPoints = 9;
	::Const.Tactical.Actor.GoblinShaman.Hitpoints = 70;
	::Const.Tactical.Actor.GoblinShaman.Bravery = 80;
	::Const.Tactical.Actor.GoblinShaman.Stamina = 90;
	::Const.Tactical.Actor.GoblinShaman.MeleeSkill = 60;
	::Const.Tactical.Actor.GoblinShaman.RangedSkill = 60;
	::Const.Tactical.Actor.GoblinShaman.MeleeDefense = 10;
	::Const.Tactical.Actor.GoblinShaman.RangedDefense = 10;
	::Const.Tactical.Actor.GoblinShaman.Initiative = 110;

	// Optional Stats
	::Const.Tactical.Actor.GoblinShaman.Vision <- 8;
}

// scripts/entity/tactical/enemies/orc_young
{
	// Mandatory stats
	::Const.Tactical.Actor.OrcYoung.XP = 450;				// Vanilla: 250
	::Const.Tactical.Actor.OrcYoung.ActionPoints = 9;		// Vanilla: 9
	::Const.Tactical.Actor.OrcYoung.Hitpoints = 130;		// Vanilla: 125
	::Const.Tactical.Actor.OrcYoung.Bravery = 65;			// Vanilla: 65
	::Const.Tactical.Actor.OrcYoung.Stamina = 150;			// Vanilla: 150
	::Const.Tactical.Actor.OrcYoung.MeleeSkill = 60;		// Vanilla: 60
	::Const.Tactical.Actor.OrcYoung.RangedSkill = 50;		// Vanilla: 50
	::Const.Tactical.Actor.OrcYoung.MeleeDefense = -5;		// Vanilla: -5
	::Const.Tactical.Actor.OrcYoung.RangedDefense = -5;		// Vanilla: -5
	::Const.Tactical.Actor.OrcYoung.Initiative = 120;		// Vanilla: 120
}

// scripts/entity/tactical/enemies/orc_berserker
{
	// Mandatory stats
	::Const.Tactical.Actor.OrcBerserker.XP = 810;
	::Const.Tactical.Actor.OrcBerserker.ActionPoints = 9;
	::Const.Tactical.Actor.OrcBerserker.Hitpoints = 250;
	::Const.Tactical.Actor.OrcBerserker.Bravery = 90;
	::Const.Tactical.Actor.OrcBerserker.Stamina = 250;
	::Const.Tactical.Actor.OrcBerserker.MeleeSkill = 75;
	::Const.Tactical.Actor.OrcBerserker.RangedSkill = 50;
	::Const.Tactical.Actor.OrcBerserker.MeleeDefense = -5;
	::Const.Tactical.Actor.OrcBerserker.RangedDefense = -10;
	::Const.Tactical.Actor.OrcBerserker.Initiative = 125;
}

// scripts/entity/tactical/enemies/orc_warrior
{
	// Mandatory stats
	::Const.Tactical.Actor.OrcWarrior.XP = 1080;
	::Const.Tactical.Actor.OrcWarrior.ActionPoints = 8;
	::Const.Tactical.Actor.OrcWarrior.Hitpoints = 200;
	::Const.Tactical.Actor.OrcWarrior.Bravery = 70;
	::Const.Tactical.Actor.OrcWarrior.Stamina = 200;
	::Const.Tactical.Actor.OrcWarrior.MeleeSkill = 80;
	::Const.Tactical.Actor.OrcWarrior.RangedSkill = 50;
	::Const.Tactical.Actor.OrcWarrior.MeleeDefense = -10;
	::Const.Tactical.Actor.OrcWarrior.RangedDefense = -10;
	::Const.Tactical.Actor.OrcWarrior.Initiative = 120;
}

// scripts/entity/tactical/enemies/orc_warlord
{
	// Mandatory stats
	::Const.Tactical.Actor.OrcWarlord.XP = 1800;
	::Const.Tactical.Actor.OrcWarlord.ActionPoints = 9;
	::Const.Tactical.Actor.OrcWarlord.Hitpoints = 300;
	::Const.Tactical.Actor.OrcWarlord.Bravery = 80;
	::Const.Tactical.Actor.OrcWarlord.Stamina = 300;
	::Const.Tactical.Actor.OrcWarlord.MeleeSkill = 85;
	::Const.Tactical.Actor.OrcWarlord.RangedSkill = 50;
	::Const.Tactical.Actor.OrcWarlord.MeleeDefense = 10;
	::Const.Tactical.Actor.OrcWarlord.RangedDefense = 0;
	::Const.Tactical.Actor.OrcWarlord.Initiative = 125;
}
