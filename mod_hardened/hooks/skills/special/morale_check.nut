::Hardened.HooksMod.hook("scripts/skills/special/morale_check", function(q) {
	// Public
	// p.m.FleeingActionPointModifier <- 1;
	// p.m.AutoretreatActionPointModifier <- 1;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		switch (this.m.Container.getActor().getMoraleState())
		{
			case ::Const.MoraleState.Fleeing:
				ret.push({
					id = 16,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::MSU.Text.colorizeValue(1, {AddSign = true}) + " [Action Point(s)|Concept.ActionPoints]",
				});
				break;
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		local actor = this.getContainer().getActor();
		switch(actor.getMoraleState())
		{
			case ::Const.MoraleState.Fleeing:
				_properties.ActionPoints += 1;	// We use magic numbers because morale_check has no member table and we can't easily fix that
				break;
		}

		// Give player entities +1 maximum Action Point while autoretreat is on
		// This has not directly to do with morale, but this is still a fine place
		if (actor.isPlacedOnMap() && actor.getFaction() == ::Const.FactionType.Player && ::Tactical.State.isAutoRetreat())
		{
			_properties.ActionPoints += 1;	// We use magic numbers because morale_check has no member table and we can't easily fix that
		}
	}
});
