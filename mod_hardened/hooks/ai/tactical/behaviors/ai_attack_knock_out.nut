::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_knock_out", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.PossibleSkills.push("actives.hd_bearded_blade");	// Similar to how the vanilla whip disarm is already part of this AI behavior, we now add the axe disarm to it too
	}
});
