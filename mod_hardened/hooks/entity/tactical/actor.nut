::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// public
	q.m.GrantsXPOnDeath <- true;

	q.onInit = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/special/hd_direct_damage_limiter"));
	}

	q.wait = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/effects/hd_wait_effect"));
	}

	q.playIdleSound = @(__original) function()
	{
		// Characters who are off-screen no longer produce idle sounds. However they will still be randomly selected as targets for making the idle sound.
		if (this.isPlacedOnMap() && this.getTile().IsVisibleForPlayer)
		{
			__original();
		}
	}

	q.playSound = @(__original) function( _type, _volume, _pitch = 1.0 )
	{
		// An actor that dies offscreen no longer produces a death sound
		if (_type == ::Const.Sound.ActorEvent.Death && !(this.isPlacedOnMap() && this.getTile().IsVisibleForPlayer))
		{
			return;
		}

		__original(_type, _volume, _pitch = 1.0);
	}

	q.hasZoneOfControl = @(__original) function()
	{
		return __original() && this.getCurrentProperties().CanExertZoneOfControl;
	}

	// For Vanilla you'd hook onActorKilled on player.nut. But Reforged moved the exp calculation over into the onDeath of actor.nut
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		local lootTile = _tile;
		if (lootTile == null && this.isPlacedOnMap()) lootTile = this.getTile();
		if (lootTile != null)
		{
			foreach (item in this.getDroppedLoot(_killer, _skill, _fatalityType))
			{
				item.drop(lootTile);
			}
		}

		local oldGlobalXPMult = ::Const.Combat.GlobalXPMult;
		if (this.isAlliedWithPlayer() || !this.m.GrantsXPOnDeath)
		{
			::Const.Combat.GlobalXPMult = 0;	// The player no longer gains any experience when allies are dying
		}

		__original(_killer, _skill, _tile, _fatalityType);

		::Const.Combat.GlobalXPMult = oldGlobalXPMult;
	}

// New Events
	// This is called just before onDeath of this entity is called
	q.getDroppedLoot <- function( _killer, _skill, _fatalityType )
	{
		return [];
	}
});
