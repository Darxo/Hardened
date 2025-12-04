::Hardened.removeTooClosePenalty("scripts/skills/actives/demolish_armor_skill");

::Hardened.HooksMod.hook("scripts/skills/actives/demolish_armor_skill", function(q) {
	q.m.HD_DamageArmorMult <- 1.6;	// Vanilla: 1.45

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
		if (_skill != this) return __original(_skill, _targetEntity, _properties);

		// We revert any changes to DamageArmorMult done by Vanilla because we want to
		//	- disable the vanilla Hammer Mastery effect
		//	- change the armor multiplier and make it moddable
		local oldDamageArmorMult = _properties.DamageArmorMult;
		__original(_skill, _targetEntity, _properties);
		_properties.DamageArmorMult = oldDamageArmorMult;

		// Now we apply our moddable DamageArmorMult
		_properties.DamageArmorMult *= this.m.HD_DamageArmorMult;
	}
});
