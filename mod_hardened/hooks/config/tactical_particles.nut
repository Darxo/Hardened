// Improvie visibility of fire and start it with yellow color
::Const.Tactical.FireParticles[0].Stages[0].ColorMin = ::createColor("ffff0080");	// In Vanilla this is ffe7cf00
::Const.Tactical.FireParticles[0].Stages[0].ColorMax = ::createColor("ffff80ff");	// In Vanilla this is ffeacf00
::Const.Tactical.FireParticles[0].Stages[1].ColorMin = ::createColor("ff9900ff");	// In Vanilla this is ff813dff
::Const.Tactical.FireParticles[0].Stages[1].ColorMax = ::createColor("ffcc00ff");	// In Vanilla this is fec19fff
::Const.Tactical.FireParticles[0].Stages[2].ColorMin = ::createColor("ff3300ff");	// In Vanilla this is fc6a52f0
::Const.Tactical.FireParticles[0].Stages[2].ColorMax = ::createColor("ff6600ff");	// In Vanilla this is fcaa52f0

// New Particle Effects

// This effect spawns a single big black, slightly transparent skull with 1s delay at the center of the targeted tile, which raises for around 2 seconds before disappearing
::Const.Tactical.HD_PlayerDeath <- [
	{
		Delay = 1000,	// Animation plays 1 second delayed, so that the blood rain has time to settle and player have time to look at the corpse
		Quantity = 1,
		LifeTimeQuantity = 1,
		SpawnRate = 2,
		Brushes = [
			"effect_skull_01"
		],
		Stages = [
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("00000000"),
				ColorMax = this.createColor("031c0200"),
				ScaleMin = 1.75,
				ScaleMax = 2.0,
				VelocityMin = 20,
				VelocityMax = 40,
				DirectionMin = this.createVec(-0.1, 1),
				DirectionMax = this.createVec(0.1, 1),
				ForceMin = this.createVec(0, 10),
				ForceMax = this.createVec(0, 15),
			},
			{
				LifeTimeMin = 2.2,
				LifeTimeMax = 2.5,
				ColorMin = this.createColor("000000bf"),
				ColorMax = this.createColor("031c02bf"),
				ScaleMin = 2.00,
				ScaleMax = 2.25,
				VelocityMin = 80,
				VelocityMax = 100,
				DirectionMin = this.createVec(-0.1, 1),
				DirectionMax = this.createVec(0.1, 1),
				ForceMin = this.createVec(0, 10),
				ForceMax = this.createVec(0, 15),
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.4,
				ColorMin = this.createColor("00000000"),
				ColorMax = this.createColor("031c0200"),
				ScaleMin = 3.0,
				ScaleMax = 3.5,
				VelocityMin = 80,
				VelocityMax = 100,
				ForceMin = this.createVec(0, 10),
				ForceMax = this.createVec(0, 15),
			}
		]
	}
];
