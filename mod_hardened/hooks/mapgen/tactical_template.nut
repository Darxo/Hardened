::Hardened.HooksMod.hook("scripts/mapgen/tactical_template", function(q) {
	q.m.HD_IsUsingHexagonLayout <- false;	// White-List for turning hexagon map generation on

	q.m.HD_HexagonWhiteList <- [
		// "tactical.arena",		// City State Arena
		"tactical.autumn",
		"tactical.desert",
		"tactical.forest_leaves",
		"tactical.forest_snow",
		"tactical.forest",
		// "tactical.golems",		// Artifact Reliquary
		"tactical.hills_desert",
		"tactical.hills_snow",
		"tactical.hills_steppe",
		"tactical.hills_tundra",
		"tactical.hills",
		"tactical.mountain",
		"tactical.oasis",
		"tactical.plains",
		"tactical.quarry",		// Black Monolith
		// "tactical.sinkhole",		// Sunken Library
		"tactical.snow",
		"tactical.steppe",
		"tactical.swamp",
		"tactical.tundra",
	];
});

::Hardened.HooksMod.hookTree("scripts/mapgen/tactical_template", function(q) {
	q.fill = @(__original) function( _rect, _properties, _pass = 1 )
	{
		if (this.m.HD_IsUsingHexagonLayout)
		{
			::Tactical.State.m.HD_IsUsingHexagonLayout = true;
		}
		// Feat: Compile various tile related information for the currently generated tactical map
		::Hardened.Tactical.MapInfo.init();

		__original(_rect, _properties, _pass);
	}

	q.campify = @(__original) { function campify( _rect, _properties )
	{
		local oldShiftX = _properties.ShiftX;
		if (!::Tactical.State.getStrategicProperties().HD_IsAttackingLocation)
		{
			_properties.ShiftX *= -1;
		}

		__original(_rect, _properties);

		_properties.ShiftX = oldShiftX;
	}}.campify;

	q.init = @(__original) { function init()
	{
		__original();

		if (this.m.HD_HexagonWhiteList.find(this.m.Name) != null)
		{
			this.m.HD_IsUsingHexagonLayout = true;
		}

		// Bump up the map size for hexagon maps by one, if they were even before, so that the hexagon fits much better inside
		if (this.m.HD_IsUsingHexagonLayout && this.m.MinX == this.m.MinY && this.m.MinX % 2 == 0)
		{
			this.m.MinX++;
			this.m.MinY++;
		}
	}}.init;

// New Functions
	q.HD_getAllTiles <- function( _rect )
	{
		local ret = [];
		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				ret.push(::Tactical.getTileSquare(x, y));
			}
		}
		return ret;
	}
});
