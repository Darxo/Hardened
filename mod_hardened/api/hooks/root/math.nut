if (!("clamp" in ::Math))
{
	// Clamps a value between the specified minimum and maximum bounds
	::Math.clamp <- function( _value, _min, _max )
	{
		if (_min > _max)
		{
			local temp = _min;
			_min = _max;
			_max = temp;
		}

		return ::Math.min(::Math.max(_value, _min), _max);
	}
}

if (!("clampf" in ::Math))
{
	// Clamps a value between the specified minimum and maximum bounds
	::Math.clampf <- function( _value, _min, _max )
	{
		if (_min > _max)
		{
			local temp = _min;
			_min = _max;
			_max = temp;
		}

		return ::Math.minf(::Math.maxf(_value, _min), _max);
	}
}
