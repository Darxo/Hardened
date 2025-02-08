::Hardened.HooksMod.hook("scripts/skills/effects/rallied_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::MSU.String.replace(this.m.Description, "turn and can not rally others when just being rallied himself", "round");
	}

	// Overwrite because this skill is no longer removed at the end of the turn
	q.onTurnEnd = @() function() {}

	q.onRoundEnd = @(__original) function()
	{
		__original();
		this.removeSelf();
	}
});
