::Hardened.HooksMod.hook("scripts/skills/perks/perk_battle_flow", function(q) {
	q.m.StaminaRecoveredMult = 0.15;	// Reforged: 0.1

	// Overwrite, because we use current stamina instead of base stamina as reference and use our standardized recoverFatigue function to handle recovery
	q.onTargetKilled = @() { function onTargetKilled( _targetEntity, _skill )
	{
		if (!this.m.IsSpent)
		{
			this.m.IsSpent = true;
			local actor = this.getContainer().getActor();
			local recoveredFatigue = actor.getStamina() * this.m.StaminaRecoveredMult;
			actor.HD_recoverFatigue(recoveredFatigue);
			actor.setDirty(true);
		}
	}}.onTargetKilled;

	// Overwrite, because we no longer reset this effect on turn start
	q.onTurnStart = @() function() {}

	// This effect now resets on Round start so its effect works exactly as advertised on the perk description
	q.onNewRound = @(__original) function()
	{
		__original();

		this.m.IsSpent = false;
	}
});
