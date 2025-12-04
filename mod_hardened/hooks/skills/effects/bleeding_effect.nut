::Hardened.HooksMod.hook("scripts/skills/effects/bleeding_effect", function(q) {
	q.m.HD_BloodEffectPctPerStack <- 0.05;		// Each stack causes the bleed effect to be this much larger

	q.applyDamage = @(__original) function()
	{
		if (this.m.LastRoundApplied != ::Time.getRound())	// Same condition as original
		{
			local actor = this.getContainer().getActor()
			actor.spawnBloodEffect(actor.getTile(), this.m.Stacks * this.m.HD_BloodEffectPctPerStack);
		}

		__original();
	}
});
