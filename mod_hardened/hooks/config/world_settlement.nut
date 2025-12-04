// First we make sure that every settlement entry has the AdditionalSpace present. This makes future code easier
foreach (entry in ::Const.World.Settlements.Master)
{
	if (!("AdditionalSpace" in entry))
	{
		entry.AdditionalSpace <- 0;
	}
}

// We adjust the AdditionalSpace of settlements depending on their size. The goal is to make larger cities more spread out and less clustered
foreach (entry in ::Const.World.Settlements.Master)
{
	local subEntry = entry.List[0];
	if (subEntry.Script.find("small") != null)
	{
		if (subEntry.Script.find("fort") != null)
		{
			entry.AdditionalSpace += ::Hardened.Const.SettlementsSpaceModifier.SmallFort;
		}
		else
		{
			entry.AdditionalSpace += ::Hardened.Const.SettlementsSpaceModifier.Small;
		}
	}
	else if (subEntry.Script.find("medium") != null)
	{
		entry.AdditionalSpace += ::Hardened.Const.SettlementsSpaceModifier.Medium;
	}
	else if (subEntry.Script.find("large") != null)
	{
		entry.AdditionalSpace += ::Hardened.Const.SettlementsSpaceModifier.Large;
	}
}

local sortSettlementEntries = function( _a, _b )
{
	_a = _a.List[0];
	_b = _b.List[0];

	if (_a.Script.find("city_state") != null)
	{
		if (_b.Script.find("city_state") != null) return 0;
		return -1;
	}
	if (_b.Script.find("city_state") != null) return 1;

	if (_a.Script.find("large") != null)
	{
		if (_b.Script.find("large") != null) return 0;
		return -1;
	}
	if (_b.Script.find("large") != null) return 1;

	if (_a.Script.find("medium") != null)
	{
		if (_b.Script.find("medium") != null) return 0;
		return -1;
	}
	if (_b.Script.find("medium") != null) return 1;

	return 0;	// We don't care about the order of small settlements
}

// We sort the Settlement Array, so that large cities and forts are generated first.
// This should
//	- Make sure that important towns are guaranteed to find space to be generated
//	- Make important towns spawn more spaced out against each other
::Const.World.Settlements.Master.sort(sortSettlementEntries);
