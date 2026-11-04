::Hardened.animation <- {
	function getDirectionVector( _direction, _variation = 0.1)
	{
		switch (_direction)
		{
			case ::Const.Direction.N:
			{
				return { Min = ::createVec(-_variation, 0.8), Max = ::createVec(_variation, 0.8)};
				break;
			}
			case ::Const.Direction.S:
			{
				return { Min = ::createVec(-_variation, -0.8), Max = ::createVec(_variation, -0.8)};
				break;
			}
			case ::Const.Direction.NE:
			case ::Const.Direction.SE:
			{
				return { Min = ::createVec(1.0, -_variation), Max = ::createVec(1.0, _variation)};
				break;
			}
			case ::Const.Direction.NW:
			case ::Const.Direction.SW:
			{
				return { Min = ::createVec(-1.0, -_variation), Max = ::createVec(-1.0, _variation)};
				break;
			}
		}
	},

	function getDirectionForce( _direction, _force = 70 )
	{
		switch (_direction)
		{
			case ::Const.Direction.NE:
			case ::Const.Direction.NW:
			{
				return ::createVec(0, _force);
				break;
			}
			case ::Const.Direction.SE:
			case ::Const.Direction.SW:
			{
				return ::createVec(0, -_force);
				break;
			}
		}

		return ::createVec(0, 0);
	},

	getSpawnOffset = function( _direction )
	{
		switch (_direction)
		{
			case ::Const.Direction.N:
			{
				return {Min = ::createVec(-5, 15), Max = ::createVec(5, 20)};
				break;
			}
			case ::Const.Direction.S:
			{
				return {Min = ::createVec(-5, -15), Max = ::createVec(5, -20)};
				break;
			}
			case ::Const.Direction.NE:
			case ::Const.Direction.SE:
			{
				return {Min = ::createVec(20, -5), Max = ::createVec(30, 5)};
				break;
			}
			case ::Const.Direction.NW:
			case ::Const.Direction.SW:
			{
				return {Min = ::createVec(-20, -5), Max = ::createVec(-30, 5)};
				break;
			}
		}
	},
};


