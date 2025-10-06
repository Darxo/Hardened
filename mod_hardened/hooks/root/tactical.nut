local oldSpawnProjectileEffect = ::Tactical.spawnProjectileEffect;
::Tactical.spawnProjectileEffect = function( _brush, _originTile, _targetTile, _spriteSizeMult, _timeScale, _isRotated, _flip )
{
	local ret = oldSpawnProjectileEffect(_brush, _originTile, _targetTile, _spriteSizeMult, _timeScale, _isRotated, _flip);

	if (!_targetTile.IsOccupiedByActor && !_targetTile.IsEmpty)	// We are shooting at a tile with an obstacle on top
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, ret, _targetTile.getEntity().HD_onHitByProjectile.bindenv(_targetTile.getEntity()), _originTile);
	}

	return ret;
}
