::UPD.EffectType.Clarification <- 3;

::UPD.Strings.HeaderType.Clarification <- 4;
::UPD.Strings.HeaderString.push("Clarification");
::UPD.Strings.HeaderColor.push("#1e468f");

// Overwrite, because it not reasonably possible to put our adjustments inside otherwise
::UPD.getDescription = function( _info )
{
	local info = {
		Fluff = "",
		Requirement = "",
		Effects = {},
		Footer = "",
	};

	foreach (key, value in _info)
	{
		if (!(key in info))
		{
			throw "Invalid parameter: " + key;
		}
	}

	::MSU.Table.merge(info, _info);

	info.Passives <- [];
	info.Actives <- [];
	info.OneTimeEffects <- [];
	info.Clarifications <- [];

	foreach (effectInfo in info.Effects)
	{
		switch (effectInfo.Type)
		{
			case ::UPD.EffectType.Passive:
				info.Passives.push({
					Name = "Name" in effectInfo ? effectInfo.Name : "",
					Description = effectInfo.Description
				})
				break;

			case ::UPD.EffectType.Active:
				info.Actives.push({
					Name = "Name" in effectInfo ? effectInfo.Name : "",
					Description = effectInfo.Description
				})
				break;

			case ::UPD.EffectType.OneTimeEffect:
				info.OneTimeEffects.push({
					Name = "Name" in effectInfo ? effectInfo.Name : "",
					Description = effectInfo.Description
				})
				break;

			// This block is newly added by Hardened
			case ::UPD.EffectType.Clarification:
				info.Clarifications.push({
					Name = "Name" in effectInfo ? effectInfo.Name : "",
					Description = effectInfo.Description
				})
				break;

			default:
				::logError("Invalid effect type: " + effectInfo.Type);
				throw ::MSU.Exception.InvalidValue(effectInfo.Type);
		}
	}

	return this.buildDescription(info);
}

// Overwrite, because it not reasonably possible to put our adjustments inside otherwise
::UPD.buildDescription = function( _info )
{
	local ret = "";

	if (_info.Requirement != "")
	{
		ret += ::UPD.Strings.getHeader(::UPD.Strings.HeaderType.Requirement);
		ret += ::MSU.Text.color(::UPD.Strings.getHeaderColor(::UPD.Strings.HeaderType.Requirement), " " + _info.Requirement) + "\n";
	}

	ret += _info.Fluff == "" ? "" : _info.Fluff + "\n";

	foreach (passive in _info.Passives)
	{
		ret += "\n" + ::UPD.Strings.getHeader(::UPD.Strings.HeaderType.Passive, passive.Name) + "\n";
		foreach (desc in passive.Description)
		{
			ret += "• " + desc + "\n";
		}
	}

	foreach (active in _info.Actives)
	{
		ret += "\n" + ::UPD.Strings.getHeader(::UPD.Strings.HeaderType.Active, active.Name) + "\n";
		foreach (desc in active.Description)
		{
			ret += "• " + desc + "\n";
		}
	}

	foreach (effect in _info.OneTimeEffects)
	{
		ret += "\n" + ::UPD.Strings.getHeader(::UPD.Strings.HeaderType.OneTimeEffect, effect.Name) + "\n";
		foreach (desc in effect.Description)
		{
			ret += "• " + desc + "\n";
		}
	}

	// This foreach loop is newly added by Hardened
	foreach (effect in _info.Clarifications)
	{
		ret += "\n" + ::UPD.Strings.getHeader(::UPD.Strings.HeaderType.Clarification, effect.Name) + "\n";
		foreach (desc in effect.Description)
		{
			ret += "• " + desc + "\n";
		}
	}

	if (_info.Footer != "") ret += "\n" + _info.Footer;
	else ret = ret.slice(0, -1); // remove the \n

	return ret;
}
