::Hardened.HooksMod.hook("scripts/skills/special/morale_check", function(q) {
	// Public
	q.m.FleeingActionPointModifier <- 1;
	q.m.AutoRetreatActionPointModifier <- 1;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.getFleeingActionPointModifier() != 0)
		{
			ret.push({
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::MSU.Text.colorizeValue(this.getFleeingActionPointModifier(), {AddSign = true}) + " [Action Point(s)|Concept.ActionPoints]",
			});
		}

		return ret;
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// Give all actors additional Action Points while fleeing
		_properties.ActionPoints += this.getFleeingActionPointModifier();

		// Give player entities +1 maximum Action Point while autoretreat is on
		// This has not directly to do with morale, but this is still a fine place
		_properties.ActionPoints += this.getAutoRetreatActionPointModifier();
	}

// New Functions
	q.getFleeingActionPointModifier <- function()
	{
		if (this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return this.m.FleeingActionPointModifier;
		}

		return 0;
	}

	q.getAutoRetreatActionPointModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap() && actor.getFaction() == ::Const.FactionType.Player && ::Tactical.State.isAutoRetreat())
		{
			return this.m.AutoRetreatActionPointModifier;
		}

		return 0;
	}
});
