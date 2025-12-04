::Hardened.HooksMod.hook("scripts/skills/actives/throw_fire_bomb_skill", function(q) {
	q.m.HD_ForbiddenTerrainSubtypes <- [
		::Const.Tactical.TerrainSubtype.Snow,
		::Const.Tactical.TerrainSubtype.LightSnow,
	];
	q.m.HD_ForbiddenTerrainTypes <- [
		::Const.Tactical.TerrainType.ShallowWater,
		::Const.Tactical.TerrainType.DeepWater,
	];

	// Vanilla Fix: Make impact delay of fire bomb use virtual time and trigger directly after the projectile effect
	// Overwrite, because we need the vanilla effect is simply enough to just write from scratch
	q.onUse = @() function( _user, _targetTile )
	{
		local effectDelay = 1;
		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			if (_user.getTile().getDistanceTo(_targetTile) >= ::Const.Combat.SpawnProjectileMinDist)
			{
				local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
				effectDelay = ::Tactical.spawnProjectileEffect(::Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}

		_user.getItems().unequip(_user.getItems().getItemAtSlot(::Const.ItemSlot.Offhand));
		::Time.scheduleEvent(::TimeUnit.Virtual, effectDelay, this.onApply.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile,
			User = _user,
		});
	}

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

// New Functions
	q.getAffectedTiles <- function( _targetTile )
	{
		local affectedTiles = [];
		if ((this.m.HD_ForbiddenTerrainSubtypes.find(_targetTile.Subtype) == null) && (this.m.HD_ForbiddenTerrainTypes.find(_targetTile.Type) == null))
		{
			affectedTiles.push(_targetTile);
		}

		foreach (nextTile in ::MSU.Tile.getNeighbors(_targetTile))
		{
			if (this.m.HD_ForbiddenTerrainSubtypes.find(nextTile.Subtype) != null) continue;
			if (this.m.HD_ForbiddenTerrainTypes.find(nextTile.Type) != null) continue;

			affectedTiles.push(nextTile);
		}
		return affectedTiles;
	}
});
