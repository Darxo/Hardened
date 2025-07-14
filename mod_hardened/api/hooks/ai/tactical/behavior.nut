::Hardened.HooksMod.hook("scripts/ai/tactical/behavior", function(q) {
	// We always add these commonly used variables to the base class, so that hookTree on the base class are cleaner when working with this variable
	q.m.TargetTile <- null;
	q.m.Skill <- null;

// New Functions
	q.HD_queryTargetSkillMult <- function(_user, _target, _usedSkill)
	{
		return _user.getSkills().getQueryTargetValueMult(_user, _target, _usedSkill) * _target.getSkills().getQueryTargetValueMult(_user, _target, _usedSkill);
	}
});
