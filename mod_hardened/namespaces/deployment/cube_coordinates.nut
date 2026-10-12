// Cube Coordinates
::Hardened.Deployment.CubeCoordinates <- {
	function North( _distance = 1 )
	{
		return ::Hardened.Deployment.CCTile(0, 1 * _distance, -1 * _distance);
	},
	function NorthEast( _distance = 1 )
	{
		return ::Hardened.Deployment.CCTile(1 * _distance, 0, -1 * _distance);
	},
	function SouthEast( _distance = 1 )
	{
		return ::Hardened.Deployment.CCTile(1 * _distance, -1 * _distance, 0);
	},
	function South( _distance = 1 )
	{
		return ::Hardened.Deployment.CCTile(0, -1 * _distance, 1 * _distance);
	},
	function SouthWest( _distance = 1 )
	{
		return ::Hardened.Deployment.CCTile(-1 * _distance, 0, 1 * _distance);
	},
	function NorthWest( _distance = 1 )
	{
		return ::Hardened.Deployment.CCTile(-1 * _distance, 1 * _distance, 0);
	},

	// Convert Tactical.Tile into a CCTile
	function fromTacticalTile( _tacticalTile )
	{
		return ::Hardened.Deployment.CCTile(_tacticalTile.X, _tacticalTile.Y, -_tacticalTile.X -_tacticalTile.Y);
	}

	function toTacticalTile( _ccTile )
	{
		return ::Tactical.getTile(_ccTile.X, _ccTile.Y);
	}

	function fromSquareCoords( _squareCoords )
	{
		local x = _squareCoords.X;
		local y = _squareCoords.Y - (x - (x & 1)) / 2;

		return ::Hardened.Deployment.CCTile(x, y, -x - y);
	}

	function toSquareCoords( _ccTile )
	{
		return {
			X = _ccTile.X,
			Y = _ccTile.Y + (_ccTile.X - (_ccTile.X & 1)) / 2
		};
	}

	// Add two vector and return the result as a newly instantiated vector
	function add( _tile1, _tile2 )
	{
		return ::Hardened.Deployment.CCTile(_tile1.X + _tile2.X, _tile1.Y + _tile2.Y, _tile1.Z + _tile2.Z);
	}
}
