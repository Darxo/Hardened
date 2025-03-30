::Hardened.HooksMod.hook("scripts/skills/actives/rf_gain_ground_skill", function(q) {
	// Private
	q.m.IsEffectActive <- false,	// This skill will apply a debuff for the rest of this turn, controlled by this flag

	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 0;
	}

	// Overwrite, because we change the cost to 0 and 0 all the time
	q.getCostString = @() function()
	{
		return this.skill.getCostString();
	}

	// Overwrite, because we change the cost to 0 and 0 all the time
	q.onAfterUpdate = @() function( _properties ) { }
});
