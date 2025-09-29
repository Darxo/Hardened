::Hardened.HooksMod.hook("scripts/skills/actives/split_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Vanilla Fix: We set this armor penetration to 40% to be in line with the value of the only weapon granting this skill (Bardiche)
		this.m.DirectDamageMult = 0.4;	// Vanilla 0.3
	}
});
