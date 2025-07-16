::Hardened.removeTooClosePenalty("scripts/skills/actives/reap_skill");

::Hardened.HooksMod.hook("scripts/skills/actives/reap_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Vanilla Fix: For some reason, vanilla has this skill set to a different value from the weapons it appears on
		this.m.DirectDamageMult = 0.3;	// Vanilla: 0.25
	}
});
