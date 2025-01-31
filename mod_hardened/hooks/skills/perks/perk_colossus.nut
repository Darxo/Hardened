::Hardened.HooksMod.hook("scripts/skills/perks/perk_colossus", function(q) {
	q.m.HitpointsModifier <- 15;
	q.m.HitpointsMult <- 1.0;

	// QOL: Reduce perk bloat on NPCs by replacing static perks with roughly the same amount of baes stats
	q.onSpawned = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			actor.m.BaseProperties.HitpointsMult *= this.m.HitpointsMult;
			actor.m.BaseProperties.Hitpoints += this.m.HitpointsModifier;
			this.removeSelf();
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// Revert the vanilla hard coded HitpointsMult
		local oldHitpointsMult = _properties.HitpointsMult;
		__original(_properties);
		_properties.HitpointsMult = oldHitpointsMult;

		_properties.HitpointsMult *= this.m.HitpointsMult;
		_properties.Hitpoints += this.m.HitpointsModifier;
	}
});

