{	// HD_DaysRemainingTable / HD_getDayRange
	::Reforged.Text.HD_DaysRemainingTable <- [];

	local min = 0;
	local lastText = ::Reforged.Text.getDaysRemainingText(0);
	for (local i = 1; i <= 30; ++i)
	{
		local newText = ::Reforged.Text.getDaysRemainingText(i);
		if (lastText != newText)
		{
			lastText = newText;
			::Reforged.Text.HD_DaysRemainingTable.push(min);
			min = i;
		}
	}

	::Reforged.Text.HD_getDayRange <- function( _dayNumber )
	{
		local minRange = 0;
		foreach (value in ::Reforged.Text.HD_DaysRemainingTable)
		{
			if (_dayNumber >= minRange && _dayNumber < value)
			{
				local ret = " (" + minRange;
				if (minRange < (value - 1)) ret += "-" + (value - 1);		// If both numbers are equal, we only show the number once
				return ret + ")";
			}
			minRange = value;
		}
		return " (" + minRange + "+)";
	}
}

{	// HD_DaysAgoAsTable / HD_getDayAgoAsRange
	::Reforged.Text.HD_DaysAgoAsTable <- [];

	local min = 0;
	local lastText = ::Reforged.Text.getDaysAgoAsText(0);
	for (local i = 1; i <= 30; ++i)
	{
		local newText = ::Reforged.Text.getDaysAgoAsText(i);
		if (lastText != newText)
		{
			lastText = newText;
			::Reforged.Text.HD_DaysAgoAsTable.push(min);
			min = i;
		}
	}

	::Reforged.Text.HD_getDayAgoAsRange <- function( _dayNumber )
	{
		local minRange = 0;
		foreach (value in ::Reforged.Text.HD_DaysRemainingTable)
		{
			if (_dayNumber >= minRange && _dayNumber < value)
			{
				local ret = " (" + minRange;
				if (minRange < (value - 1)) ret += "-" + (value - 1);		// If both numbers are equal, we only show the number once
				return ret + ")";
			}
			minRange = value;
		}
		return " (" + minRange + "+)";
	}
}

local oldGetDaysRemainingText = ::Reforged.Text.getDaysRemainingText;
::Reforged.Text.getDaysRemainingText = function( _numDays )
{
	local ret = oldGetDaysRemainingText(_numDays);
	if (::Hardened.Mod.ModSettings.getSetting("DisplayTownDayRanges").getValue()) ret += ::Reforged.Text.HD_getDayRange(_numDays);
	return ret;
}

local oldGetDaysAgoAsText = ::Reforged.Text.getDaysAgoAsText;
::Reforged.Text.getDaysAgoAsText = function( _numDays )
{
	local ret = oldGetDaysAgoAsText(_numDays);
	if (::Hardened.Mod.ModSettings.getSetting("DisplayTownDayRanges").getValue()) ret += ::Reforged.Text.HD_getDayAgoAsRange(_numDays);
	return ret;
}
