 ::Hardened.Deployment.CCTile <- class {
	X = null;	// Axial X
	Y = null;	// Axial Y
	Z = null;

	/// 1 argument == array of 3 coordinates
	constructor( _x, _y = null, _z = null )
	{
		if (_z == null)
		{
			this.X = _x[0];
			this.Y = _x[1];
			this.Z = _x[2];
		}
		else
		{
			this.X = _x;
			this.Y = _y;
			this.Z = _z;
		}
	}

	function rotateClockWise( _centerTile )
	{
		this.X -= _centerTile.X;
		this.Y -= _centerTile.Y;
		this.Z -= _centerTile.Z;

		local oldX = this.X;
		this.X = -this.Z;
		this.Z = -this.Y;
		this.Y = -oldX;

		this.X += _centerTile.X;
		this.Y += _centerTile.Y;
		this.Z += _centerTile.Z;
	}

	function rotateCounterClockWise( _centerTile )
	{
		this.X -= _centerTile.X;
		this.Y -= _centerTile.Y;
		this.Z -= _centerTile.Z;

		local oldX = this.X;
		this.X = -this.Y;
		this.Y = -this.Z;
		this.Z = -oldX;

		this.X += _centerTile.X;
		this.Y += _centerTile.Y;
		this.Z += _centerTile.Z;
	}

	function get( _index )
	{
		if (_index == 0) return this.X;
		if (_index == 1) return this.Y;
		if (_index == 2) return this.Z;
	}

	function set( _index, _value )
	{
		if (_index == 0) this.X = _value;
		if (_index == 1) this.Y = _value;
		if (_index == 2) this.Z = _value;
	}

	function asString()
	{
		return "[" + X + ", " + Y + ", " + Z + "]";
	}

	// Return true if the coordinates of two tiles are exactly equal
	function isEqual( _otherTile )
	{
		return X == _otherTile.X && Y == _otherTile.Y && Z == _otherTile.Z;
	}
}
