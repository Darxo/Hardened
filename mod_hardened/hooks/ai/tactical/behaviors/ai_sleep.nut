::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_sleep", function(q) {
	q.queryTargetValue = @(__original) { function queryTargetValue( _user, _target, _skill = null )
	{
		// Vanilla Fix: Call queryTargetValue with the actual skill instead of null
		if (_skill == null && this.m.Skill != null && _user.getID() == this.getAgent().getActor().getID())
		{
			_skill = this.m.Skill;
		}

		return __original(_user, _target, _skill);
	}}.queryTargetValue;
});
