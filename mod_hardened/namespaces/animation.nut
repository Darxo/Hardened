::Hardened.animation <- {
	function getDirectionVector( _direction, _variation = 0.1)
	{
		switch (_direction)
		{
			case ::Const.Direction.N:
			{
				return { Min = this.createVec(-_variation, 0.8), Max = this.createVec(_variation, 0.8)};
				break;
			}
			case ::Const.Direction.S:
			{
				return { Min = this.createVec(-_variation, -0.8), Max = this.createVec(_variation, -0.8)};
				break;
			}
			case ::Const.Direction.NE:
			case ::Const.Direction.SE:
			{
				return { Min = this.createVec(1.0, -_variation), Max = this.createVec(1.0, _variation)};
				break;
			}
			case ::Const.Direction.NW:
			case ::Const.Direction.SW:
			{
				return { Min = this.createVec(-1.0, -_variation), Max = this.createVec(-1.0, _variation)};
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
				return this.createVec(0, _force);
				break;
			}
			case ::Const.Direction.SE:
			case ::Const.Direction.SW:
			{
				return this.createVec(0, -_force);
				break;
			}
		}

		return this.createVec(0, 0);
	},

	getSpawnOffset = function( _direction )
	{
		switch (_direction)
		{
			case ::Const.Direction.N:
			{
				return {Min = this.createVec(-5, 15), Max = this.createVec(5, 20)};
				break;
			}
			case ::Const.Direction.S:
			{
				return {Min = this.createVec(-5, -15), Max = this.createVec(5, -20)};
				break;
			}
			case ::Const.Direction.NE:
			case ::Const.Direction.SE:
			{
				return {Min = this.createVec(20, -5), Max = this.createVec(30, 5)};
				break;
			}
			case ::Const.Direction.NW:
			case ::Const.Direction.SW:
			{
				return {Min = this.createVec(-20, -5), Max = this.createVec(-30, 5)};
				break;
			}
		}
	},
};


