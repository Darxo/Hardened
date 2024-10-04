Hardened.Hooks.CharacterScreenStatsModule_loadTimeInformation = WorldScreenTopbarDatasource.prototype.loadTimeInformation;
WorldScreenTopbarDatasource.prototype.loadTimeInformation = function (_data, _withoutNotify)
{
	var degree = _data[WorldScreenTopbarIdentifier.TimeInformation.Degree];
	degree += 23;	// We move the day-night-icon 23 degree more to align perfectly with our midnight cycle
	if (degree > 360) degree -= 360;
	_data[WorldScreenTopbarIdentifier.TimeInformation.Degree] = degree;

	Hardened.Hooks.CharacterScreenStatsModule_loadTimeInformation.call(this, _data, _withoutNotify);
}
