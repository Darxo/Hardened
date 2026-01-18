// This table is currently very lightly used by vanilla for generating weather effects. Now that one stage of the day can have multiple time-enum values, this table isn't that useful anymore
::Const.World.TimeOfDay <- {
	Sunrise = 11,
	Midday = 3,
	Sunset = 7,
	Dusk = 8,
	Midnight = 9,
	Dawn = 10,

	// old vanilla terms. Here for backwards compatibility
	EarlyMorning = 11,	// This is a vanilla term that doesn't even exist as a vanilla string
	Morning = 0,	// Morning is also 2 and 3. Better not use it to identify Morning
	Afternoon = 4,	// Afternoon is also 6 and 7. Better not use it to identify Afternoon
	Evening = 6,	// Evening does not exist anymore. We just point it to the end of Afternoon
	Night = 9,

	// Time-of-day Strings

	// Abstractions
	function isDay( _time ) { return !this.isNight(_time) }
	function isNight( _time ) { return _time == this.Dusk || _time == this.Midnight || _time == this.Dawn }
};

// We reduce the overall Vision of every world entity, to make deliberate planning of your adventures and secondary information (footsteps, patrols, rumors) more important
::Const.World.Settings.Vision = 450;	// Vanilla: 500

// We temporarily make Badlands mirror the properties of the Black Monolith location
// They will use a barren location for fighting, lowered in the center and littered with rocks
// They will use the quarry engage image
// Todo: design unique badlands tactical arena and engage imagery
::Const.World.TerrainTacticalTemplate[::Const.World.TerrainTacticalType.Badlands] = "tactical.quarry";
::Const.World.TerrainTacticalImage[::Const.World.TerrainTacticalType.Badlands] = "engage/engage_quarry";
