::Hardened.HooksMod.hook("scripts/skills/perks/perk_fortified_mind", function(q) {
	q.m.ResolveModifier <- 25;
	q.m.ResolveModifierPerWeight <- -1;

	q.onUpdate = @(__original) function( _properties )
	{
		// Fortified Mind no longer applies any BraveryMult
		local oldBraveryMult = _properties.BraveryMult;
		__original(_properties);
		_properties.BraveryMult = oldBraveryMult;

		// Now we apply our own resolve adjustment
		_properties.Bravery += this.getResolveModifier();
	}

	// QOL: Reduce perk bloat on NPCs by replacing static perks with roughly the same amount of baes stats
	q.onSpawned = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (actor.getFaction() != ::Const.Faction.Player)
		{
			actor.m.BaseProperties.Bravery += this.getResolveModifier();	// Abstraction for the average helmet that is expected
			this.removeSelf();
		}
	}

// New Functions
	q.getResolveModifier <- function()
	{
		local resolveModifier = this.m.ResolveModifier;
		local helmetWeight = this.getContainer().getActor().getItems().getWeight([::Const.ItemSlot.Head]);
		resolveModifier += helmetWeight * this.m.ResolveModifierPerWeight;
		return resolveModifier;
	}
});
