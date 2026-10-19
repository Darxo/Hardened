{	// Barbarians
	{	// Frontline
		// scripts/entity/tactical/humans/barbarian_thrall
		::Reforged.Entities.editEntity("BarbarianThrall",
			{
				Cost = 12,
				Strength = 12,
			},
			{
				XP = 150 * ::Hardened.Global.FactionExperience.Barbarians,
				ActionPoints = 9,
				Hitpoints = 80,
				Bravery = 70,
				Stamina = 115,
				MeleeSkill = 65,
				RangedSkill = 50,
				MeleeDefense = -10,
				RangedDefense = 0,
				Initiative = 115,
			}
		);

		// scripts/entity/tactical/humans/barbarian_marauder
		::Reforged.Entities.editEntity("BarbarianMarauder",
			{
				Cost = 30,
				Strength = 30,
			},
			{
				XP = 300 * ::Hardened.Global.FactionExperience.Barbarians,
				ActionPoints = 9,
				Hitpoints = 120,
				Bravery = 80,
				Stamina = 150,
				MeleeSkill = 75,
				RangedSkill = 60,
				MeleeDefense = 10,
				RangedDefense = 0,
				Initiative = 115,
			}
		);

		// scripts/entity/tactical/humans/barbarian_champion
		::Reforged.Entities.editEntity("BarbarianChampion",		// Chosen
			{
				Cost = 50,
				Strength = 50,
				Variant = 2,	// Vanilla: 1
			},
			{
				XP = 500 * ::Hardened.Global.FactionExperience.Barbarians,
				ActionPoints = 9,
				Hitpoints = 150,
				Bravery = 90,
				Stamina = 200,
				MeleeSkill = 80,
				RangedSkill = 60,
				MeleeDefense = 15,
				RangedDefense = 10,
				Initiative = 115,
			}
		);
	}

	{	// Leader
		// scripts/entity/tactical/humans/barbarian_chosen
		::Reforged.Entities.editEntity("BarbarianChosen",	// Barbarian King
			{
				Cost = 80,
				Strength = 999,		// It is vital for the Barbarian King contract that this guy can do autobattles but not lose them. Thats why his strengh is this high
			},
			{
				XP = 800 * ::Hardened.Global.FactionExperience.Barbarians,
				ActionPoints = 9,
				Hitpoints = 150,
				Bravery = 110,
				Stamina = 250,
				MeleeSkill = 100,
				RangedSkill = 65,
				MeleeDefense = 5,
				RangedDefense = 0,
				Initiative = 75,
			}
		);
	}

	{	// Support
		// scripts/entity/tactical/humans/barbarian_beastmaster
		::Reforged.Entities.editEntity("BarbarianBeastmaster",
			{
				Cost = 20,
				Strength = 20,
			},
			{
				XP = 200 * ::Hardened.Global.FactionExperience.Barbarians,
				ActionPoints = 9,
				Hitpoints = 70,
				Bravery = 90,
				Stamina = 120,
				MeleeSkill = 70,
				RangedSkill = 55,
				MeleeDefense = 0,
				RangedDefense = 20,
				Initiative = 110,
			}
		);

		// scripts/entity/tactical/humans/barbarian_beastmaster
		::Reforged.Entities.editEntity("BarbarianDrummer",
			{
				Cost = 30,
				Strength = 30,
			},
			{
				XP = 300 * ::Hardened.Global.FactionExperience.Barbarians,
				ActionPoints = 9,
				Hitpoints = 90,
				Bravery = 80,
				Stamina = 150,
				MeleeSkill = 65,
				RangedSkill = 40,
				MeleeDefense = 0,
				RangedDefense = 0,
				Initiative = 90,
			}
		);
	}

	{	// Special
		// scripts/entity/tactical/humans/barbarian_madman
		::Reforged.Entities.editEntity("BarbarianMadman",	// Barbarian Madman
			null,
			{
				XP = 800 * ::Hardened.Global.FactionExperience.Barbarians,
				ActionPoints = 9,
				Hitpoints = 160,
				Bravery = 100,
				Stamina = 200,
				MeleeSkill = 80,
				RangedSkill = 0,
				MeleeDefense = 0,	// Vanilla: 10
				RangedDefense = 0,	// Vanilla: 10
				Initiative = 115,
			}
		);
	}
}
