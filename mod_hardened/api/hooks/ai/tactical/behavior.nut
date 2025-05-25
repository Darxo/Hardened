::Hardened.HooksMod.hook("scripts/ai/tactical/behavior", function(q) {
// New Functions
	q.HD_queryTargetSkillMult <- function(_user, _target, _usedSkill)
	{
		return _user.getSkills().getQueryTargetValueMult(_user, _target, _usedSkill) * _target.getSkills().getQueryTargetValueMult(_user, _target, _usedSkill);
	}
});
