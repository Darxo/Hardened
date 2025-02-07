::Hardened.HooksMod.hook("scripts/skills/backgrounds/pimp_background", function(q) {
	q.onChangeAttributes = @(__original) function()
	{
		local ret = __original();

		ret.MeleeSkill[0] = 0;	// In Vanilla this is -5
		ret.MeleeSkill[1] = 5;	// In Vanilla this is -5

		return ret;
	}
});
