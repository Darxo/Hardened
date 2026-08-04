::Hardened.HooksMod.hook("scripts/skills/effects/charmed_effect", function (q) {
	q.m.HD_LastsForTurns = 1;

	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "This character has been charmed. He no longer has any control over his actions and is a puppet that has no choice but to obey his master.\n\nThe higher a character\'s resolve, the higher the chance to resist being charmed.";
	}

	q.getName = @(__original) function()
	{
		return __original() + " (x" + this.m.HD_LastsForTurns + ")";
	}

	q.getDescription = @() function()
	{
		return this.m.Description;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		this.m.HD_LastsForTurns = this.HD_getDebuffDuration(this.m.HD_LastsForTurns);
		local actor = this.getContainer().getActor();
		if (!actor.isHiddenToPlayer())
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " is charmed for " + ::MSU.Text.colorPositive(this.m.HD_LastsForTurns) + " turns");
		}
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		// Feat: temporarily charmed units are now less likely to be targeted by their former allies
		if (_properties.IsStunned)
		{
			_properties.TargetAttractionMult *= 0.1;
		}
		else
		{
			_properties.TargetAttractionMult *= 0.5;
		}
	}

	// Overwrite, to disable the vanilla this.m.TurnsLeft handling
	q.onTurnEnd = @() function() {}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		local actor = this.getContainer().getActor();
		if (_target.getID() == actor.getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			// It is not a good idea to attack someone who was only temporarily charmed
			ret *= 0.8;
		}

		return ret;
	}
});
