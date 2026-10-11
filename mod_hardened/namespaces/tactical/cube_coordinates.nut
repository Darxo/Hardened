// Cube Coordinates
::Hardened.Tactical.CubeCoordinates <- {
	function North( _distance = 1 )
	{
		return this.CCTile(0, 1 * _distance, -1 * _distance);
	},
	function NorthEast( _distance = 1 )
	{
		return this.CCTile(1 * _distance, 0, -1 * _distance);
	},
	function SouthEast( _distance = 1 )
	{
		return this.CCTile(1 * _distance, -1 * _distance, 0);
	},
	function South( _distance = 1 )
	{
		return this.CCTile(0, -1 * _distance, 1 * _distance);
	},
	function SouthWest( _distance = 1 )
	{
		return this.CCTile(-1 * _distance, 0, 1 * _distance);
	},
	function NorthWest( _distance = 1 )
	{
		return this.CCTile(-1 * _distance, 1 * _distance, 0);
	},

	CCTile = class {
		X = null;
		Y = null;
		Z = null;

		axialX = null;	// Vanilla axial coords coordinates
		axialY = null;	// Vanilla axial coords coordinates

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

			axialX = this.X;
			axialY = this.Y;
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

		// Normalize this vector compared to the Origin point
		function darxoNormalize()
		{
			local hexDistance = getHexDistance();
			return ::modLOSFIX.CubeCoordinates.CCTile(X / hexDistance, Y / hexDistance, Z / hexDistance);
		}

		function getHexDistance( _otherTile = null )
		{
			if (_otherTile == null) _otherTile = ::modLOSFIX.CubeCoordinates.Origin();
			return (::fabs(X - _otherTile.X) + ::fabs(Y - _otherTile.Y) + ::fabs(Z - _otherTile.Z)) / 2.0;
		}
	}

	// Convert Tactical.Tile into a CCTile
	function fromTacticalTile( _tacticalTile )
	{
		return this.CCTile(_tacticalTile.X, _tacticalTile.Y, -_tacticalTile.X -_tacticalTile.Y);
	}

	function toTacticalTile( _ccTile )
	{
		return ::Tactical.getTile(_ccTile.X, _ccTile.Y);
	}

	function fromSquareCoords( _squareCoords )
	{
		return this.CCTile(_squareCoords.X, _squareCoords.Y, -_squareCoords.X - _squareCoords.Y);
	}

	function toSquareCoords( _ccTile )
	{
		return {
			X = _ccTile.X,
			Y = _ccTile.Y,
		};
	}

	function cloneTile( _tile )
	{
		return this.CCTile(_tile.X, _tile.Y, _tile.Z);
	}

	function getVector( _start, _end )
	{
		return this.CCTile(_end.X - _start.X, _end.Y - _start.Y, _end.Z - _start.Z);
	}

	// Return up to two normalized direction vectors from _start to _end, expressed in one or two direction vectors
	function getNormalizedDirections( _start, _end )
	{
		local vector = this.getVector(_start, _end);
		local axisTiles = this.getAxisTiles(vector);
		if (axisTiles.len() == 1)
		{
			return [axisTiles[0].darxoNormalize()];
		}
		else
		{
			return [axisTiles[0].darxoNormalize(), axisTiles[1].darxoNormalize()];
		}
	}

	// Add two vector and return the result as a newly instantiated vector
	function add( _tile1, _tile2 )
	{
		return this.CCTile(_tile1.X + _tile2.X, _tile1.Y + _tile2.Y, _tile1.Z + _tile2.Z);
	}

// Experimental
	// Given a tile that must lie on a plane (not axis). Return 2 tiles on the two axis on both sides with the same distance to the origin
	function getAxisTiles( _tile )
	{
		local highestValue = 0;
		for (local j = 0; j <= 2; ++j)
		{
			if (_tile.get(j) == 0)
			{
				return [_tile];	// The given tile is already on an axis. We return itself as the only return value
			}
			else if (::Math.abs(_tile.get(j)) > ::Math.abs(highestValue))
			{
				highestValue = _tile.get(j);
			}
		}

		local doneFirstSet = false;
		local candidate1 = array(3, 0);
		local candidate2 = array(3, 0);
		for (local j = 0; j <= 2; ++j)
		{
			local value = _tile.get(j);
			if (value == highestValue)
			{
				candidate1[j] = highestValue;
				candidate2[j] = highestValue;
			}
			else if (!doneFirstSet)
			{
				doneFirstSet = true;
				candidate2[j] = -highestValue;
			}
			else
			{
				candidate1[j] = -highestValue;
			}
		}

		return [this.CCTile(candidate1), this.CCTile(candidate2)];
	}

	function generatePath( _start, _end )
	{
		local offset = _start;

		// From here on out, everything is treated as being from the origin

		local destination = this.getVector(_start, _end);
		local allowedTiles = this.__generatePath(destination);

		// Now we calculate the offset back on top of this

		this.transformPositions(allowedTiles, offset);

		return allowedTiles;
	}

	// Generate a path from the origin to _end
	function __generatePath( _end )
	{
		local ret = [this.Origin(), this.cloneTile(_end)];

		local normalizedVector = _end.darxoNormalize();
		local stepCenter = [normalizedVector.X, normalizedVector.Y, normalizedVector.Z];
		for (local i = 1; i < _end.getHexDistance(); ++i)
		{
			local isSingle = false;
			local doneFirstSet = false;

			// Every step has up to two tiles that are added to the path
			local candidate1 = array(3, 0);
			local candidate2 = array(3, 0);

			for (local j = 0; j <= 2; ++j)
			{
				local stepCenterValue = stepCenter[j];
				if (::fabs(stepCenterValue) == i)	// One value is already the highest absolute value
				{
					candidate1[j] = stepCenterValue;
					candidate2[j] = stepCenterValue;
				}
				else if (stepCenterValue % 1 == 0)	// We found a whole number that is not the stepCenterValue. That means all three numbers are whole and we sit directly on a single
				{
					ret.push(this.CCTile(stepCenter));
					isSingle = true;
					break;
				}
				else if (!doneFirstSet)
				{
					doneFirstSet = true;
					candidate1[j] = ::Math.floor(stepCenterValue);
					candidate2[j] = ::Math.ceil(stepCenterValue);
				}
				else
				{
					candidate1[j] = ::Math.ceil(stepCenterValue);
					candidate2[j] = ::Math.floor(stepCenterValue);
				}
			}
			stepCenter[0] += normalizedVector.X;
			stepCenter[1] += normalizedVector.Y;
			stepCenter[2] += normalizedVector.Z;

			if (isSingle) continue;

			ret.push(this.CCTile(candidate1));
			ret.push(this.CCTile(candidate2));
		}

		return ret;
	}

	function isPathPossible(_start, _destination, _allowedTiles )
	{
		local allowedDirections = this.getNormalizedDirections(_start, _destination);
		return this.__isPathPossible(_start, _destination, _allowedTiles, allowedDirections);
	}

	// is it possible to traverse from _destination to origin using only _allowedTiles, without ever backtracking?
	// We use recursion because of ease of implementation
	function __isPathPossible( _start, _destination, _allowedTiles, _allowedDirections )
	{
		// We are at the destination
		if (_start.isEqual(_destination)) return true;

		local isAllowed = false;
		foreach (tile in _allowedTiles)
		{
			if (_start.isEqual(tile))
			{
				isAllowed = true;
				break;
			}
		}
		if (!isAllowed) return false;	// We entered an invalid tile

		foreach (chosenDirection in _allowedDirections)
		{
			if (this.__isPathPossible(this.add(_start, chosenDirection), _destination, _allowedTiles, _allowedDirections))
			{
				return true;
			}
		}
		return false;
	}

	// Apply the offset _offset to all tiles in _tileArray, replacing the existing values in it
	function transformPositions( _tileArray, _offset )
	{
		foreach (index, tile in _tileArray)
		{
			_tileArray[index] = this.add(tile, _offset);
		}
	}

	function printTiles( _tileArray )
	{
		local arrayString = "";
		foreach (tile in _tileArray)
		{
			arrayString += tile.asString() + ", ";
		}
	}
}
