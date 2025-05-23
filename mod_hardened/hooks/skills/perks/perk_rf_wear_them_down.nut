// Our Implementation is not perfect. It can't deal with any delayed skills like Ranged Attacks or Lunge/Charge like abilities
// However we can deal with proxy-activations where one skill activates another one within it, if those happen instantly with no delay of course
::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_wear_them_down", function(q) {
	// Public
	q.m.FatigueDamageOnHit <- 10;
	q.m.FatigueDamageOnMiss <- 5;

	// Overwrite because we now apply a different effect on a hit
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.applyFatigueToTarget(_targetEntity, this.m.FatigueDamageOnHit);
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		this.applyFatigueToTarget(_targetEntity, this.m.FatigueDamageOnMiss);
	}

	q.onBeingAttacked = @() function( _attacker, _skill, _properties ) {}	// This perk no longer rerolls attacks

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;		// We must be the _user
		if (_user.getID() != _target.getID()) return ret;		// _user and _target must not be the same

		if (_target.getSkills().hasSkill("perk.rf_wear_them_down"))
		{
			ret *= 0.9;	// There is little sense in attacking someone who is already debuffed, as the debuff does not stack
		}
		else
		{
			local remainingFatigue = _target.getFatigueMax() - _target.getFatigue();
			if (remainingFatigue > 0 && remainingFatigue <= 15)
			{
				ret *= 1.2;	// An enemy with with some, but only very little remaining fatigue is a very good target considering our Wear them Down perk
			}
		}

		return ret;
	}

// New Functions
	// Apply _fatigue to _targetEntity and add rf_worn_down_effect to it, if they are fully fatigued after that
	q.applyFatigueToTarget <- function( _targetEntity, _fatigue )
	{
		if (_fatigue != 0)
		{
			_targetEntity.setFatigue(::Math.min(_targetEntity.getFatigueMax(), _targetEntity.getFatigue() + _fatigue));
		}

		if (_targetEntity.getFatigue() == _targetEntity.getFatigueMax())
		{
			_targetEntity.getSkills().add(::new("scripts/skills/effects/rf_worn_down_effect"));
		}
	}
});
