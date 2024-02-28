// This table is currently very lightly used by vanilla for generating weather effects. Now that one stage of the day can have multiple time-enum values, this table isn't that useful anymore
::Const.World.TimeOfDay <- {
	Sunrise = 0,
	Midday = 4,
	Sunset = 8,
	Dusk = 9,
	Midnight = 10,
	Dawn = 11,

	// old vanilla terms. Here for backwards compatibility
	EarlyMorning = 0,	// This is a vanilla term that doesn't even exist as a vanilla string
	Morning = 1,	// Morning is also 2 and 3. Better not use it to identify Morning
	Afternoon = 5,	// Afternoon is also 6 and 7. Better not use it to identify Afternoon
	Evening = 7,	// Evening does not exist anymore. We just point it to the end of Afternoon
	Night = 10,

	// Time-of-day Strings

	// Abstractions
	function isDay( _time ) { return _time >= this.Sunrise && _time <= this.Sunset; }
	function isNight( _time ) { return !isDay(_time); }
};
