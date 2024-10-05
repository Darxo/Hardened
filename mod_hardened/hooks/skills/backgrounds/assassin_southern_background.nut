::Hardened.HooksMod.hook("scripts/skills/backgrounds/assassin_southern_background", function(q) {
	q.onChangeAttributes = @(__original) function()
	{
		local ret = __original();

		ret.RangedSkill[0] = 5;		// In Vanilla this is 0
		ret.RangedSkill[1] = 10;	// In Vanilla this is 0

		return ret;
	}
});
