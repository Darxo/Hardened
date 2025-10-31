::Hardened.HooksMod.hook("scripts/skills/actives/rf_line_breaker_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We use a modified icon that has more contrast and lightness so it is easier to tell apart from its greyed out version
		this.m.Icon = "skills/hd_line_breaker_skill.png";
	}
});
