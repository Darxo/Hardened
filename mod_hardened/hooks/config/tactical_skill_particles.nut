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
