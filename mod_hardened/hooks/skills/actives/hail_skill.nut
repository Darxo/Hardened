::Hardened.HooksMod.hook("scripts/skills/actives/hail_skill", function(q) {
	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);

		// We play up to two additional slightly delayed hit-sounds to improve the audio feedback when fighting with/against three headed flails
		if (this.m.RerollDamageMult == 1.0)	// Indicator, that all three attacks hit the target
		{
			::Time.scheduleEvent(::TimeUnit.Real, 100, this.onPlayHitSound.bindenv(this), {
				Sound = ::MSU.Array.rand(this.m.SoundOnHit),
				Pos = _targetTile.Pos,
			});
			::Time.scheduleEvent(::TimeUnit.Real, 200, this.onPlayHitSound.bindenv(this), {
				Sound = ::MSU.Array.rand(this.m.SoundOnHit),
				Pos = _targetTile.Pos,
			});
		}
		else if (this.m.RerollDamageMult > 0.5)	// Indicator, that at least two attacks hit the target
		{
			::Time.scheduleEvent(::TimeUnit.Real, 100, this.onPlayHitSound.bindenv(this), {
				Sound = ::MSU.Array.rand(this.m.SoundOnHit),
				Pos = _targetTile.Pos,
			});
		}

		return ret;
	}
});
