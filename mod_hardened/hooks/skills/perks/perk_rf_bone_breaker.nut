::Hardened.wipeClass("scripts/skills/perks/perk_rf_bone_breaker", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bone_breaker", function(q) {
	// Private
	q.m.Temp_IsInEffect <- false;	// If true, then we are in a skill hit, from a valid skill
	q.m.Temp_HitInfoReference <- null;		// Reference to the hitinfo of the current hit
	q.m.Temp_InjuryMockObject <- null;		// Mockobject for the applyInjury function of actor.nut

	q.create = @(__original) function()
	{
		__original();
		// We need to apply our effect before most other effect, because we re-implement the vanilla applyInjury logic during onTargetHit
		// And some perks might expect the injury to be inflicted by that time
		this.m.Order = ::Const.SkillOrder.Perk - 500;
	}

	q.onBeforeTargetHit = @(__original) function( _skill, _targetEntity, _hitInfo )
	{
		__original(_skill, _targetEntity, _hitInfo);

		this.m.Temp_IsInEffect = false;
		if (this.isSkillValid(_skill) && _targetEntity.getArmor(_hitInfo.BodyPart) != 0)
		{
			this.m.Temp_IsInEffect = true;
			// We save a reference to the current _hitInfo so that we still have access to it later during the onTargetHit
			this.m.Temp_HitInfoReference = _hitInfo;

			this.m.Temp_InjuryMockObject = ::Hardened.mockFunction(_targetEntity, "applyInjury", function(_skill, _hitInfo) {
				return { done = true, value = null };
			});
		}
	}

	// Overwrite, because we completely wiped this class anyways
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!this.m.Temp_IsInEffect) return;

		// We turn on the applyInjuries function on the target again
		if (this.m.Temp_InjuryMockObject != null)
		{
			this.m.Temp_InjuryMockObject.cleanup();
			this.m.Temp_InjuryMockObject = null;
		}

		if (!_targetEntity.isAlive() || _targetEntity.isDying()) return;

		// First we hard-codedly check against the existance of Crippling Strikes, which allows injuries on undead in Reforged
		if (_targetEntity.getFlags().has("undead") && !_targetEntity.getFlags().has("ghoul") && !_targetEntity.getFlags().has("ghost") && !this.getContainer().hasSkill("perk.crippling_strikes"))
		{
			return;
		}

		local oldDamageInflictedHitpoints = this.m.Temp_HitInfoReference.DamageInflictedHitpoints;

		// We actually implement the Bonebreaker effect, by adding armor damage dealt on top of Hitpoint damage for the purpose of injuries
		this.m.Temp_HitInfoReference.DamageInflictedHitpoints += this.m.Temp_HitInfoReference.DamageInflictedArmor;

		local boneBreakerInjury = null;
		// We need to replicate any vanilla pre-condition for even considering to apply an injury
		if (_targetEntity.getCurrentProperties().IsAffectedByInjuries && _targetEntity.m.IsAbleToDie && this.m.Temp_HitInfoReference.DamageInflictedHitpoints >= ::Const.Combat.InjuryMinDamage && _targetEntity.getCurrentProperties().ThresholdToReceiveInjuryMult != 0 && this.m.Temp_HitInfoReference.InjuryThresholdMult != 0 && this.m.Temp_HitInfoReference.Injuries != null)
		{
			// Now we run the modularVannilla function applyInjury to atually apply an injury on the target
			boneBreakerInjury = _targetEntity.applyInjury(_skill, this.m.Temp_HitInfoReference);
		}

		if (boneBreakerInjury != null)
		{
			if (_targetEntity.isPlayerControlled() || !_targetEntity.isHiddenToPlayer())
			{
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(_targetEntity) + "\'s " + ::Const.Strings.BodyPartName[this.m.Temp_HitInfoReference.BodyPart] + " suffers " + boneBreakerInjury.getNameOnly() + " because of \'Bone Breaker\'!");
			}
		}

		// Revert our changes to DamageInflictedHitpoints
		this.m.Temp_HitInfoReference.DamageInflictedHitpoints = oldDamageInflictedHitpoints;
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (!_skill.isAttack())
			return false;

		if (this.m.RequiredWeaponType == null)	// This variable already exists in the Reforged implementation
			return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
