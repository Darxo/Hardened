::Hardened.HooksMod.hook("scripts/skills/actives/thresh", function(q) {
	q.getTooltip = @(__original) function()
	{
		local oldHitChanceBonus = this.m.HitChanceBonus;
		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails)
		{
			this.m.HitChanceBonus -= 5;	// Flail Mastery no longer grants +5% HitChance with this skill
		}

		local ret = __original();

		this.m.HitChanceBonus = oldHitChanceBonus;

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		if (_skill != this) return __original(_skill, _targetEntity, _properties);

		local oldSpecialized = this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails;
		this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails = false;	// Flail Mastery no longer grants +5% HitChance with this skill
		__original(_skill, _targetEntity, _properties);
		this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails = oldSpecialized;
	}
});
