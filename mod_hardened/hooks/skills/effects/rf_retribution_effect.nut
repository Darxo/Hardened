::Hardened.HooksMod.hook("scripts/skills/effects/rf_retribution_effect", function(q) {
	// Private
	q.m.SkillCounterDamageTotalMult <- {};	// Keys are the SkillCounter value of the empowered skill and the Values are the damage multiplier

	// Overwrite because we apply the damage bonus during onAnySkillUsed now so we have more control and can give it to delayed skills correctly
	q.onUpdate = @() function( _properties ) {}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (::Hardened.Temp.RootSkillCounter == null)	// This case is only for tooltip previews. During skill executions this is never null
		{
			_properties.DamageTotalMult *= this.getDamageTotalMult();
		}
		else if (::Hardened.Temp.RootSkillCounter in this.m.SkillCounterDamageTotalMult)
		{
			_properties.DamageTotalMult *= this.m.SkillCounterDamageTotalMult[::Hardened.Temp.RootSkillCounter];
		}
	}

// MSU Functions
	// Overwrite because we no longer set the stacks to 0 here as this event is not accurate enough
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree ) {}

// Hardened Functions
	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);
		if (_skill.isAttack())
		{
			this.m.SkillCounterDamageTotalMult[::Hardened.Temp.RootSkillCounter] <- this.getDamageTotalMult();
			this.m.Stacks = 0;	// We set the stacks to 0 here instead of in onAnySkillExecuted because we no longer need to preserve the stacks throughout the whole execution chain
		}
	}

// New Functions
	q.getDamageTotalMult <- function()
	{
		return 1.0 + (this.m.Stacks * this.m.BonusPerStack / 100.0);
	}
});
