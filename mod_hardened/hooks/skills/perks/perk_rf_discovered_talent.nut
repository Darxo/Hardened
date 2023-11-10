::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_discovered_talent", function(q) {
	q.onAdded = @() function()	// Overwrite because a lot of the original code is now redundant and must not be executed
	{
		if (this.m.IsApplied) return;
		if (!this.getContainer().getActor().isPlayerControlled()) return;
		if (!::MSU.isKindOf(this.getContainer().getActor(), "player")) return;

		local actor = this.getContainer().getActor();
		local talents = actor.getTalents();
		for (local i = 0; i < talents.len(); i++)
		{
			if (talents[i] < 3) talents[i]++;
		}

		// Because of its perk requirement we guaranteed that there are no pending past level-ups which would otherwise be overwritten
		actor.m.Attributes.clear();
		actor.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - actor.getLevel() + 1);
		actor.m.LevelUps += 1;

		this.m.IsApplied = true;
	}
});
