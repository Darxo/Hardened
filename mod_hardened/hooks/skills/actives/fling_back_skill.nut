::Hardened.HooksMod.hook("scripts/skills/actives/fling_back_skill", function(q) {
	q.m.HD_IsMobilitySkill = true;

	q.create = @(__original) function()
	{
		__original();
		this.m.Delay = 250;		// Vanilla: 750
	}
});
