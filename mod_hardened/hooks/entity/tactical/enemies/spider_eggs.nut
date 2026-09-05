::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/spider_eggs", function(q) {
	q.m.MinimumSpiderTimer <- 2;	// Vanilla: 1
	q.m.MaximumSpiderTimer <- 3;	// Vanilla: 2

	// Private
	q.m.CurrentSpiderTimer <- 0;

	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
	}

	// Overwrite, because damage is now redirected/handled by hd_headless_effect
	q.onDamageReceived = @() function( _attacker, _skill, _hitInfo )
	{
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
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

	q.onSpawn = @(__original) function( _tile )
	{
		local oldCount = this.m.Count;

		__original(_tile);

		if (this.m.Count != oldCount)	// A spider was spawned
		{
			if (!::MSU.isNull(::Hardened.Private.LastSpawnedActor))
			{
				// Feat: Streamline all "young" spiders from spider eggs to only come in the variant 4, which has no white symbol on its back
				local body = ::Hardened.Private.LastSpawnedActor.getSprite("body");
				body.setBrush("bust_spider_body_04");	// Vanilla: 1-4;
			}
		}
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
		this.m.CurrentSpiderTimer = ::Math.rand(this.m.MinimumSpiderTimer, this.m.MaximumSpiderTimer);
	}
});
