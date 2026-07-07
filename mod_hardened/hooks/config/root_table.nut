/// ::World.getTime() returns a class instance, which we can't just change the values of or even iterate over them and read them out automatically
/// So in order to hook it properly, we create a new squirrel table and copy all values over manually
/// In this new table we can now change values as we please
local oldGetTime = ::World.getTime;
::World.getTime = function() {
	local time = oldGetTime();
	if (time == null) return time;

	local ret = {};
	// Copy the already correct values over
	ret.IsPaused <- time.IsPaused;
	ret.SecondsPerDay <- time.SecondsPerDay;
	ret.SecondsPerHour <- time.SecondsPerHour;

	ret.SecondsOfDay <- time.SecondsOfDay;
	ret.Minutes <- time.Minutes;
	ret.Hours <- time.Hours;
	ret.Days <- time.Days;
	ret.Time <- time.Time;

	// calculate TimeOfDay into a 12-block day
	ret.TimeOfDay <- ::Math.floor(time.Hours / 2);
	if (ret.Hours >= 22) ret.Days++;	// Vanilla treats hour 22 and 23 as day even though its still the previous day. So we flip the day counter over already during these hours

	// Adjust DayTime slightly
	ret.IsDaytime <- ::Const.World.TimeOfDay.isDay(ret.TimeOfDay);

	return ret;
};

// This is an alternative function that is only used in a single place in vanilla: for applying NighttimeMult
// We assume that it is meant to behave exactly like IsDayTime
::World.isDaytime = function() {
	return ::World.getTime().IsDaytime;
}

local oldSpawnEntity = ::Tactical.spawnEntity;
::Tactical.spawnEntity = { function spawnEntity( ... )
{
	vargv.insert(0, this);
	local ret = oldSpawnEntity.acall(vargv);

	// Feat: we now save a reference to the last spawned entity to make hooking of some summoning skills easier to hook
	::Hardened.Private.LastSpawnedActor = ::MSU.asWeakTableRef(ret);

	return ret;
}}.spawnEntity;
