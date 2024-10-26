::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/spider_eggs", function(q) {
	q.m.MaximumSpiderTimer <- 2;

	// Private
	q.m.CurrentSpiderTimer <- 0;

	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
	}

	// Vanilla Fix: We spawn spiders at the start of the Round (after checkEnemyRetreating())
	// instead of via Tine.scheduleEvent which does it who knows when - probably too early
	q.onRoundStart = @(__original) function()
	{
		__original();

		this.m.CurrentSpiderTimer--;
		if (this.m.CurrentSpiderTimer == 0)
		{
			this.resetSpiderTimer();
			this.onSpawn(this.getTile());
		}
	}

	// We no longer register this event via a Time.scheduleEvent function
	q.registerSpawnEvent = @() function()
	{
	}

// Reforged Events
	q.onSpawned = @(__original) function()
	{
		__original();
		this.resetSpiderTimer();
		this.m.CurrentSpiderTimer++;    // Compared to vanila we add +1 to the very first cooldown because our cooldown counts down in round 1 unlike vanilla
	}

// New Functions
	q.resetSpiderTimer <- function()
	{
		this.m.CurrentSpiderTimer = ::Math.rand(1, this.m.MaximumSpiderTimer);
	}
});
