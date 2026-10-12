{	// Nomads
	{	// Leader
		// scripts/entity/tactical/humans/nomad_leader
		::Reforged.Entities.editEntity("NomadLeader",	// Nomad Leader
			{
				HD_FormationRole = ::Hardened.Deployment.FormationRole.Center,
			},
			{
				XP = 500 * ::Hardened.Global.FactionExperience.Nomads,		// Vanilla: 375
				ActionPoints = 9,
				Hitpoints = 100,		// Vanilla: 100
				Bravery = 100,			// Vanilla: 75
				Stamina = 150,			// Vanilla: 130
				MeleeSkill = 85,		// Vanilla: 75
				RangedSkill = 70,		// Vanilla: 65
				MeleeDefense = 15,		// Vanilla: 20
				RangedDefense = 15,		// Vanilla: 15
				Initiative = 125,		// Vanilla: 125
				Vision = 8,				// Vanilla: 7
			}
		);
	}

	{	// Frontline
		// scripts/entity/tactical/humans/nomad_cutthroat
		::Reforged.Entities.editEntity("NomadCutthroat",	// Nomad Cutthroat
			null,
			{
				XP = 150 * ::Hardened.Global.FactionExperience.Nomads,
				ActionPoints = 9,
				Hitpoints = 55,
				Bravery = 50,
				Stamina = 100,
				MeleeSkill = 60,
				RangedSkill = 45,
				MeleeDefense = 0,
				RangedDefense = 0,
				Initiative = 130,
				Vision = 8,			// Vanilla: 7
			}
		);

		// scripts/entity/tactical/humans/nomad_outlaw
		::Reforged.Entities.editEntity("NomadOutlaw",	// Nomad Outlaw
			null,
			{
				XP = 300 * ::Hardened.Global.FactionExperience.Nomads,		// Vanilla: 250
				ActionPoints = 9,
				Hitpoints = 75,			// Vanilla: 75
				Bravery = 70,			// Vanilla: 60
				Stamina = 120,			// Vanilla: 125
				MeleeSkill = 75,		// Vanilla: 65
				RangedSkill = 70,		// Vanilla: 55
				MeleeDefense = 15,		// Vanilla: 15
				RangedDefense = 15,		// Vanilla: 15
				Initiative = 140,		// Vanilla: 115
				Vision = 8,				// Vanilla: 7
			}
		);
	}

	{	// Ranged
		// scripts/entity/tactical/humans/nomad_slinger
		::Reforged.Entities.editEntity("NomadSlinger",	// Nomad Slinger
			null,
			{
				XP = 150 * ::Hardened.Global.FactionExperience.Nomads,
				ActionPoints = 9,
				Hitpoints = 50,
				Bravery = 50,
				Stamina = 100,
				MeleeSkill = 45,
				RangedSkill = 65,
				MeleeDefense = 0,
				RangedDefense = 5,
				Initiative = 110,
				Vision = 8,			// Vanilla: 7
			}
		);

		// scripts/entity/tactical/humans/nomad_archer
		::Reforged.Entities.editEntity("NomadArcher",	// Nomad Archer
			null,
			{
				XP = 240 * ::Hardened.Global.FactionExperience.Nomads,		// Vanilla: 225
				ActionPoints = 9,
				Hitpoints = 60,			// Vanilla: 60
				Bravery = 60,			// Vanilla: 55
				Stamina = 110,			// Vanilla: 115
				MeleeSkill = 60,		// Vanilla: 50
				RangedSkill = 75,		// Vanilla: 65
				MeleeDefense = 0,		// Vanilla: 5
				RangedDefense = 20,		// Vanilla: 15
				Initiative = 120,		// Vanilla: 110
				Vision = 8,
			}
		);
	}

	{	// Elite
		// scripts/entity/tactical/humans/executioner
		::Reforged.Entities.editEntity("Executioner",	// Nomad Executioner
			null,
			{
				XP = 400 * ::Hardened.Global.FactionExperience.Nomads,		// Vanilla: 450
				ActionPoints = 9,
				Hitpoints = 120,		// Vanilla: 170
				Bravery = 90,			// Vanilla: 90
				Stamina = 160,			// Vanilla: 160
				MeleeSkill = 85,		// Vanilla: 85
				RangedSkill = 50,		// Vanilla: 50
				MeleeDefense = 25,		// Vanilla: 30
				RangedDefense = 10,		// Vanilla: 20
				Initiative = 140,		// Vanilla: 115
				Vision = 8,				// Vanilla: 7
			}
		);

		// scripts/entity/tactical/humans/desert_devil
		::Reforged.Entities.editEntity("DesertDevil",	// Blade Dancer
			null,
			{
				XP = 500 * ::Hardened.Global.FactionExperience.Nomads,
				ActionPoints = 9,
				Hitpoints = 70,
				Bravery = 90,
				Stamina = 130,
				MeleeSkill = 90,
				RangedSkill = 50,
				MeleeDefense = 40,
				RangedDefense = 20,
				Initiative = 150,
				Vision = 8,			// Vanilla: 7
			}
		);

		// scripts/entity/tactical/humans/desert_stalker
		::Reforged.Entities.editEntity("DesertStalker",	// Desert Stalker
			null,
			{
				XP = 500 * ::Hardened.Global.FactionExperience.Nomads,
				ActionPoints = 9,
				Hitpoints = 60,
				Bravery = 70,
				Stamina = 135,
				MeleeSkill = 70,
				RangedSkill = 90,
				MeleeDefense = 10,
				RangedDefense = 40,
				Initiative = 140,
				Vision = 8,
			}
		);
	}
}

{	// City State
	{	// Frontline
		// scripts/entity/tactical/humans/conscript
		::Reforged.Entities.editEntity("Conscript",	// Conscript
			null,
			{
				XP = 250 * ::Hardened.Global.FactionExperience.CityStates,
				ActionPoints = 9,
				Hitpoints = 70,
				Bravery = 70,
				Stamina = 120,
				MeleeSkill = 70
				RangedSkill = 50,
				MeleeDefense = 10,
				RangedDefense = 0,
				Initiative = 110,
			}
		);
	}

	{	// Ranged
		// scripts/entity/tactical/humans/gunner
		::Reforged.Entities.editEntity("Gunner",	// Gunner
			null,
			{
				XP = 300 * ::Hardened.Global.FactionExperience.CityStates,
				ActionPoints = 9,
				Hitpoints = 60,
				Bravery = 70,
				Stamina = 120,
				MeleeSkill = 65,
				RangedSkill = 75,
				MeleeDefense = 5,
				RangedDefense = 20,
				Initiative = 120,
			}
		);
	}

	{	// Elite
		// scripts/entity/tactical/humans/assassin
		::Reforged.Entities.editEntity("Assassin",	// Assassin
			{
				HD_FormationRole = ::Hardened.Deployment.FormationRole.Flank,
			},
			{
				XP = 400 * ::Hardened.Global.FactionExperience.CityStates,
				ActionPoints = 9,
				Hitpoints = 80,
				Bravery = 85,
				Stamina = 125,
				MeleeSkill = 80,
				RangedSkill = 70,
				MeleeDefense = 10,
				RangedDefense = 10,
				Initiative = 180,
			}
		);
	}

	{	// Leader
		// scripts/entity/tactical/humans/officer
		::Reforged.Entities.editEntity("Officer",	// Officer
			{
				HD_FormationRole = ::Hardened.Deployment.FormationRole.Center,
			},
			{
				XP = 500 * ::Hardened.Global.FactionExperience.CityStates,
				ActionPoints = 9,
				Hitpoints = 110,
				Bravery = 85,
				Stamina = 150,
				MeleeSkill = 85,
				RangedSkill = 60,
				MeleeDefense = 25,
				RangedDefense = 10,
				Initiative = 110,
			}
		);
	}

	{	// Siege
		// scripts/entity/tactical/humans/engineer
		::Reforged.Entities.editEntity("Engineer",	// Engineer
			null,
			{
				XP = 200 * ::Hardened.Global.FactionExperience.CityStates,
				ActionPoints = 9,
				Hitpoints = 60,
				Bravery = 70,
				Stamina = 120,
				MeleeSkill = 60,
				RangedSkill = 80,
				MeleeDefense = 0,
				RangedDefense = 10,
				Initiative = 100,
			}
		);
	}

	{	// Misc
		// scripts/entity/tactical/humans/slave
		::Reforged.Entities.editEntity("Slave",	// Slave
			null,
			{
				XP = 30 * ::Hardened.Global.FactionExperience.Slaves,		// Vanilla: 50
				ActionPoints = 9,
				Hitpoints = 45,			// Vanilla: 55
				Bravery = 30,			// Vanilla: 40
				Stamina = 100,			// Vanilla: 100
				MeleeSkill = 40,		// Vanilla: 40
				RangedSkill = 35,		// Vanilla: 35
				MeleeDefense = 0,		// Vanilla: 5
				RangedDefense = 0,		// Vanilla: 5
				Initiative = 90,		// Vanilla: 90
			}
		);

		// scripts/entity/tactical/humans/gladiator
		::Reforged.Entities.editEntity("Gladiator",	// Gladiator
			null,
			{
				XP = 450 * ::Hardened.Global.FactionExperience.Nomads,		// Vanilla: 350
				ActionPoints = 9,
				Hitpoints = 110,		// Vanilla: 110
				Bravery = 100,			// Vanilla: 90
				Stamina = 150,			// Vanilla: 135
				MeleeSkill = 85,		// Vanilla: 75
				RangedSkill = 75,		// Vanilla: 65
				MeleeDefense = 20,		// Vanilla: 20
				RangedDefense = 0,		// Vanilla: 10
				Initiative = 130,		// Vanilla: 125
			}
		);
	}
}

// scripts/entity/tactical/humans/conscript_polearm
::Const.Tactical.Actor.HD_ConscriptPolearm <- {
	XP = 250 * ::Hardened.Global.FactionExperience.CityStates,
	ActionPoints = 9,
	Hitpoints = 60,
	Bravery = 70,
	Stamina = 120,
	MeleeSkill = 70,
	RangedSkill = 50,
	MeleeDefense = 0,
	RangedDefense = 0,
	Initiative = 110,
	Armor = [0, 0],
};
