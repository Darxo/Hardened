::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_marksmanship", function(q) {
	// Public
	q.m.DamageModifier <- 10;
	q.m.RequiredIsolationDistance <- 2;

	// Overwrite because we scale the damage differently
	q.onUpdate = @() function(_properties)
	{
		if (this.isEnabled())
		{
			_properties.TargetAttractionMult *= 1.10;

			local bonus = this.getDamageBonus();
			_properties.DamageRegularMin += bonus;
			_properties.DamageRegularMax += bonus;
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return true;	// While on the world map, we want to display the damage bonus to the player

		local numAdjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), this.m.RequiredIsolationDistance).len();
		return (numAdjacentEnemies == 0);
	}

	q.getDamageBonus <- function()
	{
		return this.m.DamageModifier;
	}
});
