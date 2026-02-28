// Improve Visibility of Miasma
// Miasma transparence at main stage is changed from 2d down to 80, making them more visible
// Miasma red tone is been reduced during main stage, making some clouds more green looking
// Miasma clouds are a bit smaller so that they are less likely to reveal the southern hex outline by being clipped by it.
// 	This also helps them to be a bit less covering, considering they have less transparency
// Miasma dissipates ~2.5 seconds earlier causing them to stack more towards the lower half/start of the animation making that part more visible
::Const.Tactical.MiasmaParticles[0].Stages[0].ScaleMin = 0.25;	// In Vanilla this is 0.25
::Const.Tactical.MiasmaParticles[0].Stages[0].ScaleMax = 0.40;	// In Vanilla this is 0.50
::Const.Tactical.MiasmaParticles[0].Stages[1].ScaleMin = 0.40;	// In Vanilla this is 0.50
::Const.Tactical.MiasmaParticles[0].Stages[1].ScaleMax = 0.80;	// In Vanilla this is 1.00
::Const.Tactical.MiasmaParticles[0].Stages[1].ColorMin = this.createColor("7d821780");	// In Vanilla this is 9d82172d
::Const.Tactical.MiasmaParticles[0].Stages[1].ColorMax = this.createColor("f5e6aa80");	// In Vanilla this is f5e6aa2d
::Const.Tactical.MiasmaParticles[0].Stages[1].LifeTimeMin = 2.0;	// Vanilla: 4.0
::Const.Tactical.MiasmaParticles[0].Stages[1].LifeTimeMax = 3.0;	// Vanilla: 6.0

/// This is a small explosition of brownish particles in 360°
/// It is designed to visualize the fast and powerful collision of two solid objects, e.g. weapons
::Const.Tactical.HD_ParrySparkles <- [
	{
		init = function( _myTile, _theirTile ) {
			local divider = 2 * _myTile.getDistanceTo(_theirTile);	// We normalize the tile-distance by dividing by twice the tile distance. This way we arrive roughly at the border of our own tile
			local x = _theirTile.Pos.X - _myTile.Pos.X;
			local y = _theirTile.Pos.Y - _myTile.Pos.Y;
			local vector = this.createVec(x / divider , y / divider + 40);	// +40 for picturing the height
			this.Stages[0].SpawnOffsetMin = vector;
			this.Stages[0].SpawnOffsetMax = vector;
		},
		Delay = 0,
		Quantity = 10,
		LifeTimeQuantity = 10,
		SpawnRate = 100,
		Brushes = [
			"hd_sparkleflare_small",
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.1,
				ColorMin = this.createColor("ffbb8800"),
				ColorMax = this.createColor("ffffff00"),
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 80,
				VelocityMax = 80,
				DirectionMin = this.createVec(-0.5, -0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(500, 0),
				SpawnOffsetMax = this.createVec(500, 0)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffbb88cc"),  // More orange, fiery
				ColorMax = this.createColor("ffffffcc"),  // Lighter yellow/orange
				// ColorMin = this.createColor("ffcc66ff"),
				// ColorMax = this.createColor("ffffccff"),
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 80,
				VelocityMax = 80,
				ForceMin = this.createVec(-15, -30),
				ForceMax = this.createVec(15, 30)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffbb8800"),
				ColorMax = this.createColor("ffffff00"),
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 80,
				VelocityMax = 80,
				ForceMin = this.createVec(-15, -30),
				ForceMax = this.createVec(15, 30)
			}
		]
	}
];

/// This is a small cylinder of purple/lack smoke that rises from the targeted point directly upwards
/// It is designed to be played continuously to signal the persistance of a reanimation of zombies. Its lifetime is usually managed by some outside manager
::Const.Tactical.HD_Reanimation <- [{
	Delay = 0,
	Quantity = 30,
	LifeTimeQuantity = 0,	// Infinite duration
	SpawnRate = 8,
	Brushes = [
		"effect_fire_01",
		"effect_fire_02",
		"effect_fire_03",
	],
	Stages = [
		{
			LifeTimeMin = 1.75,
			LifeTimeMax = 2.25,
			ColorMin = this.createColor("7025bec0"),
			ColorMax = this.createColor("a025beff"),
			ScaleMin = 1,
			ScaleMax = 1,
			RotationMin = 0,
			RotationMax = 359,
			TorqueMin = -10,
			TorqueMax = 10,
			VelocityMin = 10,
			VelocityMax = 30,
			DirectionMin = this.createVec(-0.1, 0.5),
			DirectionMax = this.createVec(0.1, 0.5),
			SpawnOffsetMin = this.createVec(-5, 0),
			SpawnOffsetMax = this.createVec(5, 0),
			ForceMin = this.createVec(0, 20),
			ForceMax = this.createVec(0, 30),
		},
		{
			LifeTimeMin = 1.00,
			LifeTimeMax = 1.00,
			ColorMin = this.createColor("7025be00"),
			ColorMax = this.createColor("a025be00"),
			ScaleMin = 1.25,
			ScaleMax = 1.25,
			RotationMin = 0,
			RotationMax = 359,
		},
	],
}];

/// This is a grey dust cloud effect that rises very briefly from a targeted point 180° upwards
/// It is designed to be multiplied by an intensity value just before being executed to archieve a scaled effect depending on strength of attack
/// This is used by perk_rf_rattle (Full Force Perk)
::Const.Tactical.HD_FullForce <- [
	{
		Delay = 1,
		Quantity = 20,
		LifeTimeQuantity = 20,
		SpawnRate = 100,
		Brushes = [
			"ash_01",
			"ash_02",
			"ash_light_01",
			"ash_light_02",
		],
		Stages = [
			{
				LifeTimeMin = 0.25,
				LifeTimeMax = 0.4,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.3,
				ScaleMax = 0.4,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				DirectionMin = this.createVec(-1.0, -0.25),
				DirectionMax = this.createVec(1.0, 0.25),
				SpawnOffsetMin = this.createVec(-50, -60),
				SpawnOffsetMax = this.createVec(50, 30),
				ForceMin = this.createVec(0, 45),
				ForceMax = this.createVec(0, 45)
			},
			{
				LifeTimeMin = 0.25,
				LifeTimeMax = 0.4,
				ColorMin = this.createColor("ffffffff"),
				ColorMax = this.createColor("ffffffff"),
				ScaleMin = 0.4,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 30,
				VelocityMax = 50,
				DirectionMin = this.createVec(-0.5, -0.25),
				DirectionMax = this.createVec(0.5, 0.25),
				ForceMin = this.createVec(0, 45),
				ForceMax = this.createVec(0, 45)
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 0.7,
				ColorMin = this.createColor("fffffff0"),
				ColorMax = this.createColor("fffffff0"),
				ScaleMin = 0.5,
				ScaleMax = 0.6,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 20,
				VelocityMax = 30,
				DirectionMin = this.createVec(0.0, 0.0),
				DirectionMax = this.createVec(0.0, 0.0),
				ForceMin = this.createVec(0, 45),
				ForceMax = this.createVec(0, 45)
			},
			{
				LifeTimeMin = 0.7,
				LifeTimeMax = 0.9,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.6,
				ScaleMax = 0.7,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 20,
				VelocityMax = 30,
				DirectionMin = this.createVec(0.0, 0.0),
				DirectionMax = this.createVec(0.0, 0.0),
				ForceMin = this.createVec(0, 45),
				ForceMax = this.createVec(0, 45)
			}
		]
	}
];

::Const.Tactical.HD_FireLanceDirectionalParticles <- [
	{
		init = function( _startTile, _destinationTile ) {
			local direction = _startTile.getDirectionTo(_destinationTile);
			this.Stages[0].SpawnOffsetMin = ::Hardened.animation.getSpawnOffset(direction).Min;
			this.Stages[0].SpawnOffsetMax = ::Hardened.animation.getSpawnOffset(direction).Max;
			this.Stages[0].DirectionMin = ::Hardened.animation.getDirectionVector(direction, 0.1).Min;
			this.Stages[0].DirectionMax = ::Hardened.animation.getDirectionVector(direction, 0.1).Max;
			this.Stages[1].DirectionMin = ::Hardened.animation.getDirectionVector(direction).Min;
			this.Stages[1].DirectionMax = ::Hardened.animation.getDirectionVector(direction).Max;
			foreach (entry in this.Stages)
			{
				entry.ForceMin = ::Hardened.animation.getDirectionForce(direction, 70);
				entry.ForceMax = ::Hardened.animation.getDirectionForce(direction, 70);
			}
		},

		Delay = 100,
		Quantity = 230,
		LifeTimeQuantity = 230,
		SpawnRate = 256,
		Brushes = [
			"effect_fire_01",
			"effect_fire_02",
			"effect_fire_03"
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.1,
				ColorMin = this.createColor("ffe7cf00"),
				ColorMax = this.createColor("ffeacf00"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 200,
				VelocityMax = 300,
				DirectionMin = this.createVec(1.0, -0.1),
				DirectionMax = this.createVec(1.0, 0.1),
				SpawnOffsetMin = this.createVec(20, -2),
				SpawnOffsetMax = this.createVec(30, 8),
				ForceMin = this.createVec(0, 70),
				ForceMax = this.createVec(0, 70)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.4,
				ColorMin = this.createColor("ff813dff"),
				ColorMax = this.createColor("fec19fff"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 200,
				VelocityMax = 300,
				DirectionMin = this.createVec(1.0, -0.1),
				DirectionMax = this.createVec(1.0, 0.1),
				ForceMin = this.createVec(0, 70),
				ForceMax = this.createVec(0, 70)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.4,
				ColorMin = this.createColor("fc6a52f0"),
				ColorMax = this.createColor("fcaa52f0"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 200,
				VelocityMax = 300,
				ForceMin = this.createVec(0, 70),
				ForceMax = this.createVec(0, 70)
			},
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("d8380000"),
				ColorMax = this.createColor("d8380000"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 200,
				VelocityMax = 300,
				ForceMin = this.createVec(0, 70),
				ForceMax = this.createVec(0, 70)
			}
		]
	},
	{
		init = function( _startTile, _destinationTile ) {
			local direction = _startTile.getDirectionTo(_destinationTile);
			this.Stages[0].SpawnOffsetMin = ::Hardened.animation.getSpawnOffset(direction).Min;
			this.Stages[0].SpawnOffsetMax = ::Hardened.animation.getSpawnOffset(direction).Max;
			this.Stages[0].DirectionMin = ::Hardened.animation.getDirectionVector(direction, 0.2).Min;
			this.Stages[0].DirectionMax = ::Hardened.animation.getDirectionVector(direction, 0.2).Max;
			this.Stages[1].ForceMin = ::Hardened.animation.getDirectionForce(direction, 35);
			this.Stages[1].ForceMax = ::Hardened.animation.getDirectionForce(direction, 35);
			this.Stages[2].ForceMin = ::Hardened.animation.getDirectionForce(direction, 35);
			this.Stages[2].ForceMax = ::Hardened.animation.getDirectionForce(direction, 35);
		},

		Delay = 200,
		Quantity = 50,
		LifeTimeQuantity = 50,
		SpawnRate = 20,
		Brushes = [
			"ash_01"
		],
		Stages = [
			{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 60,
				VelocityMax = 100,
				DirectionMin = this.createVec(1.0, -0.2),
				DirectionMax = this.createVec(1.0, 0.2),
				SpawnOffsetMin = this.createVec(15, -2),
				SpawnOffsetMax = this.createVec(25, 8)
			},
			{
				LifeTimeMin = 2.0,
				LifeTimeMax = 3.0,
				ColorMin = this.createColor("ffffffff"),
				ColorMax = this.createColor("ffffffff"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				VelocityMin = 60,
				VelocityMax = 100,
				ForceMin = this.createVec(0, 30),
				ForceMax = this.createVec(0, 40)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.3,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 0,
				VelocityMax = 0,
				ForceMin = this.createVec(0, 30),
				ForceMax = this.createVec(0, 40)
			}
		]
	}
];
