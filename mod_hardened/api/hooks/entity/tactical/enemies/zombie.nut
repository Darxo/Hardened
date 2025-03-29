::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie", function(q) {
	// Public
	q.m.MinResurrectDelay <- 1;
	q.m.MaxResurrectDelay <- 2;

	// We adjust the resurrecting of zombies so that use member variables for for deciding in how many rounds they resurrect
	q.generateCorpse = @(__original) function( _tile, _fatalityType, _killer )
	{
		local resurrectDelay = this.getResurrectRounds();
		local mockScheduleEvent;
		mockScheduleEvent = ::Hardened.mockFunction(::Time, "scheduleEvent", function( _timeUnit, _amount, _callback, _data ) {
			if (_amount >= 1 && _amount <= 2)
			{
				return { done = true, value = mockScheduleEvent.original(_timeUnit, resurrectDelay, _callback, _data) };
			}
		});

		local ret = __original(_tile, _fatalityType, _killer);

		mockScheduleEvent.cleanup();

		return ret;
	}

// New Functions
	// Return the amount of rounds in which this corpse should be resurrected as a zombie, if the roll happened so
	q.getResurrectRounds <- function()
	{
		return ::Math.rand(this.m.MinResurrectDelay, this.m.MaxResurrectDelay);
	}
});
