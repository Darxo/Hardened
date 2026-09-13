::Const.Tactical.AmbientLightingColor.Time = [
	"#ffffff",	// Morning
	"#ffffff",	// Morning
	"#ffffff",	// Monring
	"#ffffff",	// Midday
	"#ffffff",	// Afternoon
	"#ffffff",	// Afternoon
	"#ffffff",	// Afternoon
	"#f8c3be",	// Sunset
	"#b0c7f4",	// Dusk
	"#6c96d7",	// Night
	"#b0c7f4",	// Dawn
	"#ffc092",	// Sunrise
];

::Const.Tactical.AmbientLightingSaturation.Time = [
	1.0,	// Morning
	1.0,	// Morning
	1.0,	// Morning
	1.0,	// Midday
	1.0,	// Afternoon
	1.0,	// Afternoon
	1.0,	// Afternoon
	0.9,	// Sunset
	0.7,	// Dusk
	0.7,	// Night	// Vanilla: 0.5
	0.7,	// Dawn
	0.9,	// Sunrise
];

// Is at least one location drawn into this combat?
::Const.Tactical.CombatInfo.HD_IsFightingAtLocation <- false;

// Is the player hostile to the location?
::Const.Tactical.CombatInfo.HD_IsAttackingLocation <- false;

// Does the location spawn small raised outpusts at the corners?
// This will not work, if the camp already is at a level of 3
::Const.Tactical.LocationTemplate.HD_HasWatchposts <- false;
