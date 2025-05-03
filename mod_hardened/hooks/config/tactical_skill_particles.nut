// Improve Visibility of Miasma
// Miasma transparence at main stage is changed from 2d down to 50, making them more visible
// Miasma red tone is been reduced during main stage, making some clouds more green looking
// Miasma clouds are a bit smaller so that they are less likely to reveal the southern hex outline by being clipped by it.
// 	This also helps them to be a bit less covering, considering they have less transparency
::Const.Tactical.MiasmaParticles[0].Stages[0].ScaleMin = 0.25;	// In Vanilla this is 0.25
::Const.Tactical.MiasmaParticles[0].Stages[0].ScaleMax = 0.40;	// In Vanilla this is 0.50
::Const.Tactical.MiasmaParticles[0].Stages[1].ScaleMin = 0.40;	// In Vanilla this is 0.50
::Const.Tactical.MiasmaParticles[0].Stages[1].ScaleMax = 0.80;	// In Vanilla this is 1.00
::Const.Tactical.MiasmaParticles[0].Stages[1].ColorMin = this.createColor("7d821750");	// In Vanilla this is 9d82172d
::Const.Tactical.MiasmaParticles[0].Stages[1].ColorMax = this.createColor("f5e6aa50");	// In Vanilla this is f5e6aa2d

::Const.Tactical.Reanimation <- [{
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
