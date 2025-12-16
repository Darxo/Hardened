::Hardened.HooksMod.hook("scripts/skills/actives/rf_pummel_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.IsAttack = true;		// This skill inherits from line_breaker, which we made into a non-attack. Since this skill is now an actual attack, we need to re-enable it
	}
});
