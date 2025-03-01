::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_dynamic_duo_abstract", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// Dynamic Duo Partner no longer gain melee stats when something happens to the other person
		this.m.MeleeSkillModifier = 0;
		this.m.MeleeDefenseModifier = 0;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.UpdateWhenTileOccupationChanges = true;	// Because our bonus is applied depending on how many adjacent allies there are
	}

	// Overwrite because we dont reduce chance to hit the partner or reduce damage when hitting the partner
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties ) {}
});

