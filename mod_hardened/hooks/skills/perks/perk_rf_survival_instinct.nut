::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_survival_instinct", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// There is no maximum amount of stacks for hits anymore
		this.m.HitStacksMax = 100;
		this.m.BonusPerHit = 10;	// In Reforged this is 5

		// Misses no longer have any impact
		this.m.MissStacksMax = 0;
		this.m.BonusPerMiss = 0;
	}

	// Overwrite, because we display only one type of stacks without any name attached to the type
	q.getName = @() function()
	{
		local name = this.m.Name;

		if (this.m.HitStacks > 0)
		{
			name += " (x" + this.m.HitStacks + ")";
		}

		return name;
	}

	// Overwrite because miss stacks no longer accumulate like in Reforged
	q.onMissed = @() function( _attacker, _skill )
	{
		if (_skill != null && _skill.isAttack() && _attacker != null && _attacker.getID() != this.getContainer().getActor().getID())
		{
			this.m.HitStacks = ::Math.max(0, this.m.HitStacks - 1);
		}
	}

	q.onCombatStarted = @(__original) function()
	{
		__original();
		this.m.HitStacks = 1;
	}
});
