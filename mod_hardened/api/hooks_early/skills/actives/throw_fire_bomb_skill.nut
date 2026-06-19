::Hardened.HooksMod.hook("scripts/skills/actives/throw_fire_bomb_skill", function(q) {
	// Overwrite, because we don't highlight tiles, which would be forbidden
	q.onTargetSelected = @() function( _targetTile )
	{
		foreach (t in this.getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, t, t.Pos.X, t.Pos.Y);
		}
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return __original(_originTile, _targetTile) && (this.getAffectedTiles(_targetTile).len() != 0);
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);
		if (_skill != this) return ret;
		if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

		if (_user.getID() == this.getContainer().getActor().getID())	// We must be the _user
		{
			if (_target.getCurrentProperties().IsRooted)
			{
				if (_target.isAlliedWith(_user))
				{
					ret *= 1.5;		// It's a good idea to target rooted allies to free them from those roots
				}
				else
				{
					ret *= 0.7;		// It's a bad idea to target rooted enemies, because this skill removes rooted effects on a hit
				}
			}
		}

		return ret;
	}

// New Functions
	q.getAffectedTiles <- function( _targetTile )
	{
		local affectedTiles = [];
		local forbiddenSubTypes = ::Tactical.Entities.getNonFlammableTileSubtypes();

		if (forbiddenSubTypes.find(_targetTile.Subtype) == null)
		{
			affectedTiles.push(_targetTile);
		}

		foreach (nextTile in ::MSU.Tile.getNeighbors(_targetTile))
		{
			if (forbiddenSubTypes.find(_targetTile.Subtype) != null) continue;

			affectedTiles.push(nextTile);
		}
		return affectedTiles;
	}
});
