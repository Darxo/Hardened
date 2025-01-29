::Hardened.HooksMod.hook("scripts/skills/effects/net_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.MeleeDefenseMult = 0.5;	// In Vanilla this is 0.55
		this.m.RangedDefenseMult = 0.5;	// In Vanilla this is 0.55
		this.m.InitiativeMult = 1.0;	// In Vanilla this is 0.55
	}
});
