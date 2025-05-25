local oldScheduleEvent = ::Time.scheduleEvent;
::Time.scheduleEvent = function( _timeUnit, _time, _function, _data )
{
	if (::Hardened.Temp.RootSkillCounter == null) return oldScheduleEvent(_timeUnit, _time, _function, _data);

	if (::Hardened.getFunctionCaller() == "frameUpdate")	// frameUpdate is a function that fires constantly in vanilla. We skip our skill counter magic for it
	{
		return oldScheduleEvent(_timeUnit, _time, _function, _data);
	}

	local dataWrap = { data = _data };	// In Vanilla its allowed to pass any data type here so we need to wrap it to guarantee there is space for our async counter
	dataWrap.RootSkillCounter <- ::Hardened.Temp.RootSkillCounter;

	local oldCallback = _function;
	_function = function( _tag )
	{
		::Hardened.Temp.RootSkillCounter = _tag.RootSkillCounter;
		oldCallback(_tag.data);
		::Hardened.Temp.RootSkillCounter = null;
	}

	oldScheduleEvent(_timeUnit, _time, _function, dataWrap);
}

// We save the original Values of these vanilla constants, so that we can adjust the vanilla values according to current game speed
local originalIdleSoundMinDelay = ::Const.Sound.IdleSoundMinDelay;
local originalIdleSoundBaseDelay = ::Const.Sound.IdleSoundBaseDelay;
local originalIdleSoundReducedDelay = ::Const.Sound.IdleSoundReducedDelay;

local oldSetVirtualSpeed = ::Time.setVirtualSpeed;
::Time.setVirtualSpeed = function( _timeMult )
{
	// Fix(Vanilla): Idle Sounds playing much more frequently on higher game speed
	::Const.Sound.IdleSoundMinDelay = _timeMult * originalIdleSoundMinDelay;
	::Const.Sound.IdleSoundBaseDelay = _timeMult * originalIdleSoundBaseDelay;
	::Const.Sound.IdleSoundReducedDelay = _timeMult * originalIdleSoundReducedDelay;

	oldSetVirtualSpeed(_timeMult);
}
