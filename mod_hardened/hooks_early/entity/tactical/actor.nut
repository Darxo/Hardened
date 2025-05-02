::Hardened.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Overwrite because we don't want the Vanilla way of calculating
	q.getFatigueMax = @() function()
	{
		return this.getStamina();
	}

	// Overwrite because we don't want the Vanilla way of calculating
	// Changes:
	// 	- Weight now affects your Initiative AFTER multipliers (instead of before)
	// 	- Effects, which lower your Stamina below your BaseStamina no longer lower your Initiative
	q.getInitiative = @() function()
	{
		local initiative = this.m.CurrentProperties.getInitiative();	// This includes base initiative, modifier and multiplier
		initiative -= this.getFatigue() * this.m.CurrentProperties.FatigueToInitiativeRate;		// Subtract Accumulated Fatigue from Initiative
		initiative += this.getInitiativeModifierFromWeight();	// Subtract Weight from Initiative
		return ::Math.round(initiative);
	}
});
