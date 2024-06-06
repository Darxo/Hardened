::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
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
});
