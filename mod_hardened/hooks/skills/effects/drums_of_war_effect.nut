::Hardened.HooksMod.hook("scripts/skills/effects/drums_of_war_effect", function (q) {
	q.m.HD_FatigueRecovered <- 15;

// Modular Vanilla Functions
	// Overwrite, because we prevent vanilla from spawning a manual additional overlay icon,
	//	because adding an effect to a character already spawns an overlay icon
	// We also make this effect more moddable and make it use our new recoverFatigue function
	q.onAdded = @() function()
	{
		local actor = this.getContainer().getActor();
		actor.HD_recoverFatigue(this.m.HD_FatigueRecovered, false);
	}
});
