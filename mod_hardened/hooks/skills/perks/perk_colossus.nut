::Hardened.HooksMod.hook("scripts/skills/perks/perk_colossus", function(q) {
	// QOL: Reduce perk bloat on NPCs by replacing static perks with roughly the same amount of baes stats
	q.onCombatStarted = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			actor.m.BaseProperties.HitpointsMult *= 1.25;
			this.removeSelf();
		}
	}
});

