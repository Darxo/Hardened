::Hardened.HooksMod.hook("scripts/entity/tactical/human", function(q) {
	// Public
	q.m.ResurrectionChance <- 33;	// Chance for this character to turn into a zombie if all other conditions align
	q.m.MinResurrectDelay <- 2;	// Minimum duration of rounds after which this character resurrects as a zombie
	q.m.MaxResurrectDelay <- 3;	// Maximum duration of rounds after which this character resurrects as a zombie

	q.generateCorpse = @(__original) function( _tile, _fatalityType, _killer )
	{
		// We mock isUndeadScourge to make Vanilla believe that it is never undead scourge so that it never naturally resurrects corpses
		local mockIsUndeadScourge = ::Hardened.mockFunction(::World.FactionManager, "isUndeadScourge", function() {
			return { done = true, value = false };
		});
		local ret = __original(_tile, _fatalityType, _killer);
		mockIsUndeadScourge.cleanup();

		if (this.isTurningIntoZombie(_killer, ret, _fatalityType))
		{
			ret.Faction = ::World.FactionManager.getFactionOfType(::Const.FactionType.Zombies).getID();
			ret.IsConsumable = false;
			ret.IsResurrectable = false;
			::Time.scheduleEvent(::TimeUnit.Rounds, this.getResurrectRounds(), ::Tactical.Entities.resurrect, ret);
		}

		return ret;
	}

// New Functions
	// Determines, whether this character will resurrect as a zombie
	q.isTurningIntoZombie <- function( _killer, _corpse, _fatalityType )
	{
		if (::Tactical.State.isScenarioMode()) return false;
		if (::Tactical.State.getStrategicProperties().IsArenaMode) return false;

		if (!::World.FactionManager.isUndeadScourge()) return false;
		if (!_corpse.IsResurrectable) return false;

		return ::Math.rand(1, 100) <= this.m.ResurrectionChance;
	}

	// Return the amount of rounds in which this corpse should be resurrected as a zombie
	q.getResurrectRounds <- function()
	{
		return ::Math.rand(this.m.MinResurrectDelay, this.m.MaxResurrectDelay);
	}
});
