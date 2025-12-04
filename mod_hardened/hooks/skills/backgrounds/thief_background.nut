::Hardened.HooksMod.hook("scripts/skills/backgrounds/thief_background", function(q) {
	q.onChangeAttributes = @(__original) function()
	{
		local ret = __original();

		ret.RangedDefense[1] = 5;	// Vanilla: 8

		return ret;
	}
});
