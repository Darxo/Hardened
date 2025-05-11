::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_dynamic_duo_abstract", function(q) {
	q.m.BraveryModifier <- 20;
	q.m.InitiativeModifier <- 20;

	q.create = @(__original) function()
	{
		__original();
		// Dynamic Duo Partner no longer gain melee stats when something happens to the other person
		this.m.MeleeSkillModifier = 0;
		this.m.MeleeDefenseModifier = 0;
	}

	q.getTooltip = @(__original) function()
	{
		ret = __original();

		if (this.m.BraveryModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::MSU.Text.colorizeValue(this.m.BraveryModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]"),
			});
		}

		if (this.m.InitiativeModifier != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::MSU.Text.colorizeValue(this.m.InitiativeModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Initiative|Concept.Initiative]"),
			});
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.isEnabled())
		{
			_properties.Bravery += this.m.BraveryModifier;
			_properties.Initiative += this.m.InitiativeModifier;
		}

		_properties.UpdateWhenTileOccupationChanges = true;	// Because our bonus is applied depending on how many adjacent allies there are
	}

	// Overwrite because we dont reduce chance to hit the partner or reduce damage when hitting the partner
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties ) {}
});

