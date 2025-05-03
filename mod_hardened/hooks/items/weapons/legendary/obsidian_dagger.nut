::Hardened.HooksMod.hook("scripts/items/weapons/legendary/obsidian_dagger", function(q) {
	q.onDamageDealt = @(__original) function( _target, _skill, _hitInfo )
	{
		local mockObject = ::Hardened.mockFunction(::Time, "scheduleEvent", function( _timeUnit, _time, _function, _data ) {
			if (_timeUnit == ::TimeUnit.Rounds && "HD_CorpseTouched" in _data && _data.HD_CorpseTouched != ::Time.getRound())	// We identify a corpse by the existance of the HD_CorpseTouched field
			{
				// The reanimation effects are somehow drawn behind the dead human, just for this item. Walking on top of the tile will draw them correctly in front of the corpse
				::Tactical.Entities.HD_scheduleResurrection(_time, _data);
				return { done = true, value = null };
			}
		});

		__original(_target, _skill, _hitInfo);

		mockObject.cleanup();
	}
});
