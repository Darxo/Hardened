local generateAllIterations = function( _prefixes, _suffixes )
{
	local ret = [];
	foreach (prefix in _prefixes)
	{
		foreach (suffix in _suffixes)
		{
			ret.push(prefix + " " + suffix);
		}
	}
	return ret;
}

{	// Changes
	{	// ::Const.Strings.MercenaryCompanyNames
		local mercenaryPrefixes = [
			"Azure",
			"Black",
			"Blood",
			"Bone",
			"Broken",
			"Burning Sun",
			"Crimson",
			"Exiled",
			"Forsaken",
			"Free",
			"Golden",
			"Hardened",
			"Iron",
			"Lost",
			"Northern",
			"Orcbane",
			"Rightful",
			"Silver",
			"Southern",
			"Unbroken",
			"White",
		];
		// We add randomname multiple times to allow these combinations to appear more often
		for (local i = 1; i <= 5; ++i) mercenaryPrefixes.push("%randomname%\'s");

		local mercenarySuffixes = [
			"Blades",
			"Brigade",
			"Brotherhood",
			"Brothers",
			"Circle",
			"Company",
			"Covenant",
			"Fellowship",
			"Guard",
			"Legion",
			"Men",
			"Order",
			"Pact",
			"Ravens",
			"Shields",
			"Sons",
			"Swords",
			"Wardens",
			"Watch",
		];

		::Const.Strings.MercenaryCompanyNames = generateAllIterations(mercenaryPrefixes, mercenarySuffixes);
	}
}

