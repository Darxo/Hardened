::Hardened.HooksMod.hook("scripts/skills/actives/taunt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.MaxRange = 4;	// Vanilla: 3
	}
});
