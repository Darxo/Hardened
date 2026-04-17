// scripts/entity/tactical/enemies/goblin_wolfrider
{
	// Mandatory stats
	::Const.Tactical.Actor.GoblinWolfrider.XP = 300 * ::Hardened.Global.FactionExperience.Goblins;
	::Const.Tactical.Actor.GoblinWolfrider.ActionPoints = 13;
	::Const.Tactical.Actor.GoblinWolfrider.Hitpoints = 70;
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
	::Const.Tactical.Actor.GoblinLeader.XP = 500 * ::Hardened.Global.FactionExperience.Goblins;
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
	::Const.Tactical.Actor.GoblinShaman.XP = 500 * ::Hardened.Global.FactionExperience.Goblins;
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
	::Const.Tactical.Actor.OrcYoung.XP = 250 * ::Hardened.Global.FactionExperience.Orcs;		// Vanilla: 250
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
	::Const.Tactical.Actor.OrcBerserker.XP = 450 * ::Hardened.Global.FactionExperience.Orcs;
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
	::Const.Tactical.Actor.OrcWarrior.XP = 600 * ::Hardened.Global.FactionExperience.Orcs;
	::Const.Tactical.Actor.OrcWarrior.ActionPoints = 8;
	::Const.Tactical.Actor.OrcWarrior.Hitpoints = 200;
	::Const.Tactical.Actor.OrcWarrior.Bravery = 60;
	::Const.Tactical.Actor.OrcWarrior.Stamina = 200;
	::Const.Tactical.Actor.OrcWarrior.MeleeSkill = 80;
	::Const.Tactical.Actor.OrcWarrior.RangedSkill = 50;
	::Const.Tactical.Actor.OrcWarrior.MeleeDefense = -5;
	::Const.Tactical.Actor.OrcWarrior.RangedDefense = -10;
	::Const.Tactical.Actor.OrcWarrior.Initiative = 120;
}

// scripts/entity/tactical/enemies/orc_warlord
{
	// Mandatory stats
	::Const.Tactical.Actor.OrcWarlord.XP = 1000 * ::Hardened.Global.FactionExperience.Orcs;
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

{	// Goblins
	{	// Frontline
		{	// Goblin Skirmisher
			::Reforged.Entities.addEntity(
				"HD_GoblinSkirmisher",
				"Goblin Skirmisher",
				"Goblin Skirmishers",
				"goblin_01_orientation",
				::Const.FactionType.Goblins,
				{
					Variant = 0,
					Strength = 18,
					Cost = 18,
					Row = 0,
					Script = "scripts/entity/tactical/enemies/goblin_fighter_low",
				},
				{
					XP = 180 * ::Hardened.Global.FactionExperience.Goblins,		// Vanilla: 200
					ActionPoints = 9,
					Hitpoints = 50,
					Bravery = 50,
					Stamina = 100,
					MeleeSkill = 60,
					RangedSkill = 55,
					MeleeDefense = 5,
					RangedDefense = 0,
					Initiative = 110,
					Armor = [0, 0],
				}
			);

			::Hardened.Global.addEntityFallback("scripts/entity/tactical/enemies/goblin_fighter_low", ::Const.EntityType.GoblinFighter, ::Const.EntityType.HD_GoblinSkirmisher);
		}

		{	// Goblin Fighter
			// scripts/entity/tactical/enemies/goblin_fighter
			::Reforged.Entities.editEntity("GoblinSkirmisher",
				{
					Cost = 35, 		// Reforged: 18; Vanilla: 15
					Strength = 35, 	// Reforged: 18; Vanilla: 18
				}
			);
			// scripts/entity/tactical/enemies/goblin_fighter
			::Reforged.Entities.editEntity("GoblinFighter",
				null,
				{
					XP = 350 * ::Hardened.Global.FactionExperience.Goblins,		// Vanilla: 200
					Hitpoints = 70,
					Bravery = 60,
					Stamina = 100,
					MeleeSkill = 75,
					RangedSkill = 65,
					MeleeDefense = 15,
					RangedDefense = 0,
					Initiative = 130,
				}
			);
		}
	}

	{	// Ranged
		{	// Goblin Ambusher
			::Reforged.Entities.addEntity(
				"HD_GoblinAmbusher",
				"Goblin Ambusher",
				"Goblin Ambushers",
				"goblin_04_orientation",
				::Const.FactionType.Goblins,
				{
					Variant = 0,
					Strength = 18,
					Cost = 18,
					Row = 1,
					Script = "scripts/entity/tactical/enemies/goblin_ambusher_low",
				},
				{
					XP = 180,
					ActionPoints = 9,
					Hitpoints = 40,
					Bravery = 50,
					Stamina = 100,
					MeleeSkill = 50,
					RangedSkill = 60,
					MeleeDefense = 0,
					RangedDefense = 15,
					Initiative = 110,
					Armor = [0, 0],
				}
			);

			::Hardened.Global.addEntityFallback("scripts/entity/tactical/enemies/goblin_ambusher_low", ::Const.EntityType.GoblinAmbusher, ::Const.EntityType.HD_GoblinAmbusher);
		}

		{	// Goblin Stalker
			// scripts/entity/tactical/enemies/goblin_ambusher
			::Reforged.Entities.editEntity("GoblinAmbusher",
				{
					Cost = 35, 		// Reforged: 18; Vanilla: 15
					Strength = 35, 	// Reforged: 18; Vanilla: 18
				},
				{
					XP = 350 * ::Hardened.Global.FactionExperience.Goblins,		// Vanilla: 200
					Hitpoints = 50,
					Bravery = 60,
					Stamina = 100,
					MeleeSkill = 60,
					RangedSkill = 70,
					MeleeDefense = 0,
					RangedDefense = 25,
					Initiative = 130,
					Vision = 8,
				}
			);
		}
	}
}
