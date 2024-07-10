local oldGetTime = ::World.getTime;
::World.getTime = function() {
	local time = oldGetTime();
	if (time == null) return time;

	local ret = {};
	// Copy the already correct values over
	ret.SecondsPerDay <- time.SecondsPerDay;
	ret.SecondsPerHour <- time.SecondsPerHour;

	ret.SecondsOfDay <- time.SecondsOfDay;
	ret.Minutes <- time.Minutes;
	ret.Hours <- time.Hours;
	ret.Days <- time.Days;
	ret.Time <- time.Time;

	// calculate TimeOfDay into a 12-block day
	ret.TimeOfDay <- ::Math.floor(time.Hours / 2);
	if (ret.TimeOfDay == 11) ret.Days++;	// Vanilla treats hour 22 and 23 as day even though its still the previous day. So we flip the day counter over already during these hours

	// Adjust DayTime slightly
	ret.IsDaytime <- ::Const.World.TimeOfDay.isDay(ret.TimeOfDay);

	return ret;
};
