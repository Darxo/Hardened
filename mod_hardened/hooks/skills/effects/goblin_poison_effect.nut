::Hardened.HooksMod.hook("scripts/skills/effects/goblin_poison_effect", function (q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Poisoned (Goblin)";		// Vanilla: Poisoned
	}
});
