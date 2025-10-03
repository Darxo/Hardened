::Hardened.HooksMod.hook("scripts/skills/actives/hail_skill", function(q) {
	q.m.HD_MultiHitSfxDelay <- 100;

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);

		// We play up to two additional slightly delayed hit-sounds to improve the audio feedback when fighting with/against three headed flails
		if (this.m.RerollDamageMult == 1.0)	// Indicator, that all three attacks hit the target
		{
			::Time.scheduleEvent(::TimeUnit.Real, this.m.HD_MultiHitSfxDelay, this.playTwoHitSfx.bindenv(this), {
				Sound = ::MSU.Array.rand(this.m.SoundOnHit),
				Pos = _targetTile.Pos,
			});
		}
		else if (this.m.RerollDamageMult > 0.5)	// Indicator, that at least two attacks hit the target
		{
			::Time.scheduleEvent(::TimeUnit.Real, this.m.HD_MultiHitSfxDelay, this.onPlayHitSound.bindenv(this), {
				Sound = ::MSU.Array.rand(this.m.SoundOnHit),
				Pos = _targetTile.Pos,
			});
		}

		return ret;
	}

// New Functions
	// Helper function to make sure the second delay sfx only fires after the first one has been played to prevent overlap
	q.playTwoHitSfx <- function( _data )
	{
		this.onPlayHitSound(_data);

		::Time.scheduleEvent(::TimeUnit.Real, this.m.HD_MultiHitSfxDelay, this.onPlayHitSound.bindenv(this), {
			Sound = ::MSU.Array.rand(this.m.SoundOnHit),
			Pos = _data.Pos,
		});
	}
});
