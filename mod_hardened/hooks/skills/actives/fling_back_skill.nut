::Hardened.HooksMod.hook("scripts/skills/actives/fling_back_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Delay = 250;		// Vanilla: 750
	}
});
