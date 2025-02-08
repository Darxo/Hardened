::Hardened.removeTooClosePenalty("scripts/skills/actives/demolish_armor_skill");

::Hardened.HooksMod.hook("scripts/skills/actives/demolish_armor_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		// Switcheroo to prevent vanilla to incorporate Hammer Mastery into armor damage calculations
		// This will always enable the tooClose mechanic but that is ok because we remove it anyways in Hardened
		local p = this.getContainer().getActor().getCurrentProperties();
		local oldSpecialized = p.IsSpecializedInHammers;
		p.IsSpecializedInHammers = false;

		local ret = __original();

		p.IsSpecializedInHammers = oldSpecialized;
		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		// Switcheroo to prevent vanilla to incorporate Hammer Mastery into armor damage calculations
		// This will always enable the tooClose mechanic but that is ok because we remove it anyways in Hardened
		local p = this.getContainer().getActor().getCurrentProperties();
		local oldSpecialized = p.IsSpecializedInHammers;
		p.IsSpecializedInHammers = false;	// Hammer Mastery no longer increases the armor damage from demolish armor

		__original(_skill, _targetEntity, _properties);

		p.IsSpecializedInHammers = oldSpecialized;
	}
});
