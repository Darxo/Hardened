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
