::Hardened.HooksMod.hook("scripts/skills/backgrounds/bowyer_background", function(q) {
	q.onChangeAttributes = @(__original) function()
	{
		local ret = __original();

		ret.Hitpoints[0] = -5;		// Vanilla: 0

		ret.RangedSkill[0] = 15;	// Vanilla: 10
		ret.RangedSkill[1] = 15;	// Vanilla: 10

		return ret;
	}
});
