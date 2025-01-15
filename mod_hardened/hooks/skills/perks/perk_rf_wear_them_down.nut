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
