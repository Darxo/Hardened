// In order to support delayed skills, we have to let this effect persist longer than the initial valid skill execution
// The specific implementation below works because cheap trick can only be applied once per turn
// Known issues: If you wait or end your turn before your delayed attack finished, it will not profit from cheap trick because that effect has then been removed
::Hardened.HooksMod.hook("scripts/skills/effects/rf_cheap_trick_effect", function(q) {
	q.m.SkillCounter <- null;	// This is used to bind this cheap_trick effect to the root skill that it will empower and rediscover it even through delays

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 || entry.id == 11)
			{
				entry.text = ::MSU.String.replace(entry.text, "attack", "attack skill");
			}
		}

		return ret;
	}

	// Overwrite because we need to add additional condition
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (!this.isSkillValid(_skill)) return;

		// The following condition is a smart way to cover three states
		// 1. both are null. This means cheap_trick is still available and we are not in the execution of a skill so this skill must provide its effect to adjust tooltips
		// 2. both are the same value: we are in the execution of the empowered skill or a child skill of the empowered one. We apply our effect accordingly
		// 3. SkillCounter is not null: our effect is used up, so we no longer display any tooltip adjustments
		if (this.m.SkillCounter == ::Hardened.Temp.RootSkillCounter)
		{
			_properties.MeleeSkill += this.m.HitChanceModifier;
			_properties.RangedSkill += this.m.HitChanceModifier;
			_properties.DamageRegularMult *= this.m.DamageRegularMult;
		}
	}

// MSU Functions
	// Overwrite because we no longer remove ourselves once a valid skill is executed
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree ) {}

	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		if (this.m.SkillCounter == null)	// Since this effect now persists past the initial empowerement we need to hide the hitfactors afterwards
		{
			__original(_skill, _targetTile, _tooltip);
		}
	}

// Hardened Functions
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		if (this.isSkillValid(_skill) && this.m.SkillCounter == null && ::Const.SkillCounter == ::Hardened.Temp.RootSkillCounter)
		{
			this.m.SkillCounter = ::Hardened.Temp.RootSkillCounter;	// We bind this effect to root skill so that we only affect child executions of this chain
			this.m.IsHidden = true;	// We can't remove this effect yet because there might still be a delayed effect on the way
		}
	}
});
