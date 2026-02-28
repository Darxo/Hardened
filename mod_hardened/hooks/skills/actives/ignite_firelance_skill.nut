::Hardened.HooksMod.hook("scripts/skills/actives/ignite_firelance_skill", function(q) {
	q.onDelayedEffect = @(__original) function( _tag )
	{
		foreach (entry in ::Const.Tactical.HD_FireLanceDirectionalParticles)
		{
			entry.init(_tag.User.getTile(), _tag.TargetTile);
		}

		local oldRightParticles = ::Const.Tactical.FireLanceRightParticles;
		local oldLeftParticles = ::Const.Tactical.FireLanceLeftParticles;
		::Const.Tactical.FireLanceRightParticles = ::Const.Tactical.HD_FireLanceDirectionalParticles;
		::Const.Tactical.FireLanceLeftParticles = ::Const.Tactical.HD_FireLanceDirectionalParticles;

		__original(_tag);

		::Const.Tactical.FireLanceRightParticles = oldRightParticles;
		::Const.Tactical.FireLanceLeftParticles = oldLeftParticles;
	}
});
