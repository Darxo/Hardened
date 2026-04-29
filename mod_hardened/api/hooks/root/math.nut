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

if (!("lerp" in ::Math))
{
	// Move the value _a _t% closer to the value _b
	::Math.lerp <- function( _a, _b, _t )
	{
		return _a + (_b - _a) * _t;
	}
}

if (!("compress" in ::Math))
{
	// Clamps a value between the specified minimum and maximum bounds
	::Math.compress <- function( _value, _min, _max, _t )
	{
		if (_value < _min) return ::Math.lerp(_value, _min, _t);
		if (_value > _max) return ::Math.lerp(_value, _max, _t);
		return _value;
	}
}
