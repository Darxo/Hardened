::Hardened.HooksMod.hook("scripts/skills/actives/stab", function(q) {
	// Public
	q.m.ThresholdToInflictInjuryMult <- 1.25;	// Is is ~25% harder to inflict injuries with this skil

	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 3;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = ::Reforged.Mod.Tooltips.parseString("Has a " + ::MSU.Text.colorizeMult(this.m.ThresholdToInflictInjuryMult, {InvertColor = true}) + " higher threshold to inflict [injuries|Concept.Injury]"),
		});

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		_properties.ThresholdToInflictInjuryMult *= this.m.ThresholdToInflictInjuryMult;
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		// Add an action point to counter act the discount that is given out by modular_vanilla mod
		if (_properties.IsSpecializedInDaggers)
		{
			if (this.m.ActionPointCost > 0)
			{
				this.m.ActionPointCost += 1;
			}
		}

		__original(_properties);
	}
});
