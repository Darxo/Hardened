::Const.Tactical.Actor.Donkey.XP = 0;	// In Vanilla they grant 50 XP

::Const.Tactical.Actor.Envoy.ActionPoints = 6;	// Vanilla: 9

// scripts/entity/tactical/humans/peasant
// scripts/entity/tactical/humans/peasant_southern
// scripts/entity/tactical/humans/peasant_armed
{
	// Mandatory stats
	::Const.Tactical.Actor.Peasant.XP = 40;
	::Const.Tactical.Actor.Peasant.ActionPoints = 9;
	::Const.Tactical.Actor.Peasant.Hitpoints = 55;
	::Const.Tactical.Actor.Peasant.Bravery = 30;
	::Const.Tactical.Actor.Peasant.Stamina = 100;
	::Const.Tactical.Actor.Peasant.MeleeSkill = 50;
	::Const.Tactical.Actor.Peasant.RangedSkill = 30;
	::Const.Tactical.Actor.Peasant.MeleeDefense = 5;
	::Const.Tactical.Actor.Peasant.RangedDefense = 5;
	::Const.Tactical.Actor.Peasant.Initiative = 90;
}

// scripts/entity/tactical/humans/caravan_hand
{
	// Mandatory stats
	::Const.Tactical.Actor.CaravanHand.XP = 100;
	::Const.Tactical.Actor.CaravanHand.ActionPoints = 9;
	::Const.Tactical.Actor.CaravanHand.Hitpoints = 60;
	::Const.Tactical.Actor.CaravanHand.Bravery = 30;
	::Const.Tactical.Actor.CaravanHand.Stamina = 120;
	::Const.Tactical.Actor.CaravanHand.MeleeSkill = 55;
	::Const.Tactical.Actor.CaravanHand.RangedSkill = 30;
	::Const.Tactical.Actor.CaravanHand.MeleeDefense = 0;
	::Const.Tactical.Actor.CaravanHand.RangedDefense = 0;
	::Const.Tactical.Actor.CaravanHand.Initiative = 100;
}

// scripts/entity/tactical/humans/militia
{
	// Mandatory stats
	::Const.Tactical.Actor.Militia.XP = 140;
	::Const.Tactical.Actor.Militia.ActionPoints = 9;
	::Const.Tactical.Actor.Militia.Hitpoints = 60;
	::Const.Tactical.Actor.Militia.Bravery = 70;
	::Const.Tactical.Actor.Militia.Stamina = 100;
	::Const.Tactical.Actor.Militia.MeleeSkill = 55;
	::Const.Tactical.Actor.Militia.RangedSkill = 35;
	::Const.Tactical.Actor.Militia.MeleeDefense = 5;
	::Const.Tactical.Actor.Militia.RangedDefense = 0;
	::Const.Tactical.Actor.Militia.Initiative = 90;
}

// scripts/entity/tactical/humans/militia_ranged
{
	// Mandatory stats
	::Const.Tactical.Actor.MilitiaRanged.XP = 140;
	::Const.Tactical.Actor.MilitiaRanged.ActionPoints = 9;
	::Const.Tactical.Actor.MilitiaRanged.Hitpoints = 50;
	::Const.Tactical.Actor.MilitiaRanged.Bravery = 70;
	::Const.Tactical.Actor.MilitiaRanged.Stamina = 100;
	::Const.Tactical.Actor.MilitiaRanged.MeleeSkill = 40;
	::Const.Tactical.Actor.MilitiaRanged.RangedSkill = 50;
	::Const.Tactical.Actor.MilitiaRanged.MeleeDefense = 5;
	::Const.Tactical.Actor.MilitiaRanged.RangedDefense = 0;
	::Const.Tactical.Actor.MilitiaRanged.Initiative = 75;

	// Optional Stats
	::Const.Tactical.Actor.MilitiaRanged.Vision <- 8;			// Vanilla: 7
}

// scripts/entity/tactical/humans/caravan_guard
{
	// Mandatory stats
	::Const.Tactical.Actor.CaravanGuard.XP = 200;
	::Const.Tactical.Actor.CaravanGuard.ActionPoints = 9;
	::Const.Tactical.Actor.CaravanGuard.Hitpoints = 70;
	::Const.Tactical.Actor.CaravanGuard.Bravery = 70;
	::Const.Tactical.Actor.CaravanGuard.Stamina = 120;
	::Const.Tactical.Actor.CaravanGuard.MeleeSkill = 60;
	::Const.Tactical.Actor.CaravanGuard.RangedSkill = 40;
	::Const.Tactical.Actor.CaravanGuard.MeleeDefense = 10;
	::Const.Tactical.Actor.CaravanGuard.RangedDefense = 0;
	::Const.Tactical.Actor.CaravanGuard.Initiative = 110;
}

// scripts/entity/tactical/humans/cultist
{
	// Mandatory stats
	::Const.Tactical.Actor.Cultist.XP = 200;			// Vanilla: 150
	::Const.Tactical.Actor.Cultist.ActionPoints = 9;	// Vanilla: 150
	::Const.Tactical.Actor.Cultist.Hitpoints = 90;		// Vanilla: 60
	::Const.Tactical.Actor.Cultist.Bravery = 60;		// Vanilla: 80
	::Const.Tactical.Actor.Cultist.Stamina = 110;		// Vanilla: 110
	::Const.Tactical.Actor.Cultist.MeleeSkill = 70;		// Vanilla: 60
	::Const.Tactical.Actor.Cultist.RangedSkill = 40;	// Vanilla: 40
	::Const.Tactical.Actor.Cultist.MeleeDefense = 10;	// Vanilla: 10
	::Const.Tactical.Actor.Cultist.RangedDefense = 10;	// Vanilla: 10
	::Const.Tactical.Actor.Cultist.Initiative = 110;	// Vanilla: 110
}

// scripts/entity/tactical/humans/militia_veteran
{
	// Mandatory stats
	::Const.Tactical.Actor.MilitiaVeteran.XP = 250;
	::Const.Tactical.Actor.MilitiaVeteran.ActionPoints = 9;
	::Const.Tactical.Actor.MilitiaVeteran.Hitpoints = 80;
	::Const.Tactical.Actor.MilitiaVeteran.Bravery = 70;
	::Const.Tactical.Actor.MilitiaVeteran.Stamina = 120;
	::Const.Tactical.Actor.MilitiaVeteran.MeleeSkill = 70;
	::Const.Tactical.Actor.MilitiaVeteran.RangedSkill = 50;
	::Const.Tactical.Actor.MilitiaVeteran.MeleeDefense = 15;
	::Const.Tactical.Actor.MilitiaVeteran.RangedDefense = 10;
	::Const.Tactical.Actor.MilitiaVeteran.Initiative = 110;
}

// scripts/entity/tactical/humans/bounty_hunter
{
	// Mandatory stats
	::Const.Tactical.Actor.BountyHunter.XP = 300;				// Vanilla: 300
	::Const.Tactical.Actor.BountyHunter.ActionPoints = 9;
	::Const.Tactical.Actor.BountyHunter.Hitpoints = 80;			// Vanilla: 80
	::Const.Tactical.Actor.BountyHunter.Bravery = 70;			// Vanilla: 65
	::Const.Tactical.Actor.BountyHunter.Stamina = 120;			// Vanilla: 125
	::Const.Tactical.Actor.BountyHunter.MeleeSkill = 75;		// Vanilla: 75
	::Const.Tactical.Actor.BountyHunter.RangedSkill = 75;		// Vanilla: 60
	::Const.Tactical.Actor.BountyHunter.MeleeDefense = 0;		// Vanilla: 15
	::Const.Tactical.Actor.BountyHunter.RangedDefense = 30;		// Vanilla: 8
	::Const.Tactical.Actor.BountyHunter.Initiative = 120;		// Vanilla: 120
}

// scripts/entity/tactical/humans/bounty_hunter_ranged
{
	// Mandatory stats
	::Const.Tactical.Actor.BountyHunterRanged.XP = 300;				// Vanilla: 250
	::Const.Tactical.Actor.BountyHunterRanged.ActionPoints = 9;
	::Const.Tactical.Actor.BountyHunterRanged.Hitpoints = 70;		// Vanilla: 60
	::Const.Tactical.Actor.BountyHunterRanged.Bravery = 65;			// Vanilla: 65
	::Const.Tactical.Actor.BountyHunterRanged.Stamina = 120;		// Vanilla: 115
	::Const.Tactical.Actor.BountyHunterRanged.MeleeSkill = 75;		// Vanilla: 50
	::Const.Tactical.Actor.BountyHunterRanged.RangedSkill = 75;		// Vanilla: 70
	::Const.Tactical.Actor.BountyHunterRanged.MeleeDefense = 0;		// Vanilla: 10
	::Const.Tactical.Actor.BountyHunterRanged.RangedDefense = 30;	// Vanilla: 10
	::Const.Tactical.Actor.BountyHunterRanged.Initiative = 100;		// Vanilla: 125

	// Optional Stats
	::Const.Tactical.Actor.BountyHunterRanged.Vision <- 8;
}

// scripts/entity/tactical/humans/militia_captain
{
	// Mandatory stats
	::Const.Tactical.Actor.MilitiaCaptain.XP = 350;				// Vanilla: 200; Reforged: 250
	::Const.Tactical.Actor.MilitiaCaptain.ActionPoints = 9;
	::Const.Tactical.Actor.MilitiaCaptain.Hitpoints = 90;		// Vanilla: 70; Reforged: 80
	::Const.Tactical.Actor.MilitiaCaptain.Bravery = 85;			// Vanilla: 70
	::Const.Tactical.Actor.MilitiaCaptain.Stamina = 130;		// Vanilla: 120
	::Const.Tactical.Actor.MilitiaCaptain.MeleeSkill = 70;		// Vanilla: 60; Reforged: 70
	::Const.Tactical.Actor.MilitiaCaptain.RangedSkill = 50;
	::Const.Tactical.Actor.MilitiaCaptain.MeleeDefense = 15;	// Vanilla: 10; Reforged: 15
	::Const.Tactical.Actor.MilitiaCaptain.RangedDefense = 10;	// Vanilla: 0; Reforged: 0
	::Const.Tactical.Actor.MilitiaCaptain.Initiative = 100;		// Vanilla: 100
}

// scripts/entity/tactical/humans/mercenary
{
	// Mandatory stats
	::Const.Tactical.Actor.Mercenary.XP = 350;
	::Const.Tactical.Actor.Mercenary.ActionPoints = 9;
	::Const.Tactical.Actor.Mercenary.Hitpoints = 90;
	::Const.Tactical.Actor.Mercenary.Bravery = 70;
	::Const.Tactical.Actor.Mercenary.Stamina = 135;
	::Const.Tactical.Actor.Mercenary.MeleeSkill = 75;
	::Const.Tactical.Actor.Mercenary.RangedSkill = 65;
	::Const.Tactical.Actor.Mercenary.MeleeDefense = 20;
	::Const.Tactical.Actor.Mercenary.RangedDefense = 10;
	::Const.Tactical.Actor.Mercenary.Initiative = 130;
}

// scripts/entity/tactical/humans/mercenary_ranged
{
	// Mandatory stats
	::Const.Tactical.Actor.MercenaryRanged.XP = 350;
	::Const.Tactical.Actor.MercenaryRanged.ActionPoints = 9;
	::Const.Tactical.Actor.MercenaryRanged.Hitpoints = 75;
	::Const.Tactical.Actor.MercenaryRanged.Bravery = 70;
	::Const.Tactical.Actor.MercenaryRanged.Stamina = 135;
	::Const.Tactical.Actor.MercenaryRanged.MeleeSkill = 65;
	::Const.Tactical.Actor.MercenaryRanged.RangedSkill = 75;
	::Const.Tactical.Actor.MercenaryRanged.MeleeDefense = 10;
	::Const.Tactical.Actor.MercenaryRanged.RangedDefense = 20;
	::Const.Tactical.Actor.MercenaryRanged.Initiative = 130;

	// Optional Stats
	::Const.Tactical.Actor.MercenaryRanged.Vision <- 8;
}

// scripts/entity/tactical/humans/hedge_knight
{
	// Mandatory stats
	::Const.Tactical.Actor.HedgeKnight.XP = 600;
	::Const.Tactical.Actor.HedgeKnight.ActionPoints = 9;
	::Const.Tactical.Actor.HedgeKnight.Hitpoints = 150;
	::Const.Tactical.Actor.HedgeKnight.Bravery = 90;
	::Const.Tactical.Actor.HedgeKnight.Stamina = 160;
	::Const.Tactical.Actor.HedgeKnight.MeleeSkill = 95;
	::Const.Tactical.Actor.HedgeKnight.RangedSkill = 50;
	::Const.Tactical.Actor.HedgeKnight.MeleeDefense = 40;
	::Const.Tactical.Actor.HedgeKnight.RangedDefense = 15;
	::Const.Tactical.Actor.HedgeKnight.Initiative = 100;
}

// scripts/entity/tactical/humans/master_archer
{
	// Mandatory stats
	::Const.Tactical.Actor.MasterArcher.XP = 600;
	::Const.Tactical.Actor.MasterArcher.ActionPoints = 9;
	::Const.Tactical.Actor.MasterArcher.Hitpoints = 80;
	::Const.Tactical.Actor.MasterArcher.Bravery = 70;
	::Const.Tactical.Actor.MasterArcher.Stamina = 130;
	::Const.Tactical.Actor.MasterArcher.MeleeSkill = 65;
	::Const.Tactical.Actor.MasterArcher.RangedSkill = 90;
	::Const.Tactical.Actor.MasterArcher.MeleeDefense = 15;
	::Const.Tactical.Actor.MasterArcher.RangedDefense = 70;
	::Const.Tactical.Actor.MasterArcher.Initiative = 110;

	// Optional Stats
	::Const.Tactical.Actor.MasterArcher.Vision <- 8;
}

// scripts/entity/tactical/humans/swordmaster
{
	// Mandatory stats
	::Const.Tactical.Actor.Swordmaster.XP = 800;
	::Const.Tactical.Actor.Swordmaster.ActionPoints = 9;
	::Const.Tactical.Actor.Swordmaster.Hitpoints = 80;
	::Const.Tactical.Actor.Swordmaster.Bravery = 90;
	::Const.Tactical.Actor.Swordmaster.Stamina = 130;
	::Const.Tactical.Actor.Swordmaster.MeleeSkill = 120;
	::Const.Tactical.Actor.Swordmaster.RangedSkill = 50;
	::Const.Tactical.Actor.Swordmaster.MeleeDefense = 30;
	::Const.Tactical.Actor.Swordmaster.RangedDefense = 70;
	::Const.Tactical.Actor.Swordmaster.Initiative = 130;
}
