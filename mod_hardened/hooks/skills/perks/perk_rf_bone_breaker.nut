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

	// _targetEntity may be dying or notAlive at this callgetBlockedTiles
	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!this.m.Temp_IsInEffect) return;

		// We turn on the applyInjuries function on the target
		if (this.m.Temp_InjuryMockObject != null)
		{
			this.m.Temp_InjuryMockObject.cleanup();
			this.m.Temp_InjuryMockObject = null;
		}

		local oldDamageInflictedHitpoints = this.m.Temp_HitInfoReference.DamageInflictedHitpoints;

		// We actually implement the Bonebreaker effect, by adding armor damage dealt on top of Hitpoint damage for the purpose of injuries
		this.m.Temp_HitInfoReference.DamageInflictedHitpoints += this.m.Temp_HitInfoReference.DamageInflictedArmor;

		// Now we run the modularVannilla function applyInjury to atually apply an injury on the target
		local boneBreakerInjury = _targetEntity.applyInjury(_skill, this.m.Temp_HitInfoReference);
		// In vanilla it checks for appliedInjury boolean here but we extracted the injury application into
		// a separate function which returns the injury so we check for the returned injury being null
		if (boneBreakerInjury != null)
		{
			if (_targetEntity.isPlayerControlled() || !_targetEntity.isHiddenToPlayer())
			{
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(_targetEntity) + "\'s " + ::Const.Strings.BodyPartName[this.m.Temp_HitInfoReference.BodyPart] + " suffers " + boneBreakerInjury.getNameOnly() + " because of \'Bone Breaker\'!");
			}
		}

		// Revert our changes to DamageInflictedHitpoints
		this.m.Temp_HitInfoReference.DamageInflictedHitpoints = oldDamageInflictedHitpoints;

		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
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
