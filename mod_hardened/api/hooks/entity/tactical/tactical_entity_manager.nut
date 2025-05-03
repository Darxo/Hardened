::Hardened.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	q.spawn = @(__original) function( _properties )
	{
		::Hardened.TileReservation.onCombatStarted();
		__original(_properties);
	}

	q.addCorpse = @(__original) function( _tile )
	{
		__original(_tile);
		if (_tile.Properties.has("Corpse"))
		{
			_tile.Properties.get("Corpse").RoundAdded <- ::Tactical.TurnSequenceBar.getCurrentRound();
		}
	}

	q.onResurrect = @(__original) function( _info, _force = false)
	{
		// Characters that are immune to knockback and grab will no longer be displaced by zombies reviving under them
		// This allows blocking zombie revival with skills like Indomitable
		// This also prevents silly/weird situations where unholds/orcs get pushed back by zombies or where a lindwurm is separated from their tail by a zombie
		local targetTile = _info.Tile;
		if (targetTile.IsOccupiedByActor)
		{
			local prop = targetTile.getEntity().getCurrentProperties();
			if (prop.IsImmuneToKnockBackAndGrab || prop.IsRooted)
			{
				::Time.scheduleEvent(::TimeUnit.Rounds, 1, ::Tactical.Entities.resurrect, _info);
				return null;
			}
		}

		return __original( _info, _force);
	}

	// Function for scheduling resurrections
	q.HD_scheduleResurrection <- function( _rounds, _corpse )
	{
		_corpse.HD_CorpseTouched = ::Time.getRound();	// We need to use round number, because the same corpse might persist over multiple turns; just adding a unique flag is not enough

		// Generate reanimation effect on the tile
		if (_corpse.Tile != null)
		{
			local proxyTileEffect = { Timeout = ::Time.getRound() + _rounds };
			local particles = [];
			foreach (def in ::Const.Tactical.Reanimation)
			{
				particles.push(::Tactical.spawnParticleEffect(true, def.Brushes, _corpse.Tile, def.Delay, def.Quantity, def.LifeTimeQuantity, def.SpawnRate, def.Stages));
			}
			::Tactical.Entities.addTileEffect(_corpse.Tile, proxyTileEffect, particles);
		}

		// Schedule the reanimation
		::Time.scheduleEvent(::TimeUnit.Rounds, _rounds, ::Tactical.Entities.resurrect, _corpse);
	}
});
