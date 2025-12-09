::Hardened.HooksMod.hook("scripts/skills/effects/charmed_effect", function (q) {
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
