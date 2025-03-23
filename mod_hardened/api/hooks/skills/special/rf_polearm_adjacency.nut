::Hardened.HooksMod.hook("scripts/skills/special/rf_polearm_adjacency", function(q) {
	q.isEnabledForSkill = @(__original) function( _skill )
	{
		return __original(_skill) && !_skill.m.HD_IgnoreForCrowded;
	}
});
