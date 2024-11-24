::Hardened.HooksMod.hook("scripts/skills/actives/crush_armor", function(q) {
	q.getTooltip = @(__original) function()
	{
		// Switcheroo to prevent vanilla to incorporate Hammer Mastery into armor damage calculations
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
		local p = this.getContainer().getActor().getCurrentProperties();
		local oldSpecialized = p.IsSpecializedInHammers;
		p.IsSpecializedInHammers = false;	// Hammer Mastery no longer increases the armor damage from demolish armor

		__original(_skill, _targetEntity, _properties);

		p.IsSpecializedInHammers = oldSpecialized;
	}
});
