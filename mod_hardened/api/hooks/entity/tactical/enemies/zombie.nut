::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie", function(q) {
	// Public
	q.m.MinResurrectDelay <- 1;
	q.m.MaxResurrectDelay <- 2;

	q.generateCorpse = @(__original) function( _tile, _fatalityType, _killer )
	{
		local resurrectDelay = this.getResurrectRounds();	// The resurrect delay for this zombie is now controllable

		local mockObject = ::Hardened.mockFunction(::Time, "scheduleEvent", function( _timeUnit, _time, _function, _data ) {
			if (_timeUnit == ::TimeUnit.Rounds && "HD_CorpseTouched" in _data && _data.HD_CorpseTouched != ::Time.getRound())	// We identify a corpse by the existance of the HD_CorpseTouched field
			{
				_data.Tile = _tile;		// zombie implementation of generateCorpse pushes _tile into the corpse too late for us
				::Tactical.Entities.HD_scheduleResurrection(resurrectDelay, _data);
				return { done = true, value = null };
			}
		});

		local ret = __original(_tile, _fatalityType, _killer);

		mockObject.cleanup();

		return ret;
	}

	q.onActorKilled = @(__original) function( _actor, _tile, _skill )
	{
		// Todo: Make rounds adjustable? Like With own resurrection?
		local mockObject = ::Hardened.mockFunction(::Time, "scheduleEvent", function( _timeUnit, _time, _function, _data ) {
			if (_timeUnit == ::TimeUnit.Rounds && "HD_CorpseTouched" in _data && _data.HD_CorpseTouched != ::Time.getRound())	// We identify a corpse by the existance of the HD_CorpseTouched field
			{
				::Tactical.Entities.HD_scheduleResurrection(_time, _data);
				return { done = true, value = null };
			}
		});

		__original(_actor, _tile, _skill);

		mockObject.cleanup();
	}

// New Functions
	// Return the amount of rounds in which this corpse should be resurrected as a zombie, if the roll happened so
	q.getResurrectRounds <- function()
	{
		return ::Math.rand(this.m.MinResurrectDelay, this.m.MaxResurrectDelay);
	}
});
