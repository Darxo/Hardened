::Hardened.HooksMod.hook("scripts/skills/perks/perk_fortified_mind", function(q) {
	q.m.BaseResolveMult <- 1.3;
	q.m.ResolveModifierPerWeight <- -0.01;

	q.onUpdate = @() function( _properties )
	{
		local helmetWeight = ::Math.max(0, this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Head]));
		local resolveMult = ::Math.maxf(1.0, this.m.BaseResolveMult + (this.m.ResolveModifierPerWeight * helmetWeight));
		_properties.BraveryMult *= resolveMult;
	}

	// QOL: Reduce perk bloat on NPCs by replacing static perks with roughly the same amount of baes stats
	q.onCombatStarted = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			actor.m.BaseProperties.BraveryMult *= 1.25;
			this.removeSelf();
		}
	}
});
