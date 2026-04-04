// We wipe many vanilla functions with the goal to de-couple the tail from the head
::Hardened.wipeClass("scripts/skills/perks/perk_mastery_mace", [
	"create",
	"onUpdate",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_mace", function(q) {
	// Public
	q.m.HD_FatigueCostMult <- ::Hardened.Global.WeaponSpecFatigueMult;
	q.m.HD_DazedDuration <- 1;		// A hit to the head applies dazed for this many turns

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		// Feat: We now implement the fatigue cost discount of masteries within the mastery perk
		if (this.m.HD_FatigueCostMult != 1.0)
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;
				}

				if (skill.getID() == "actives.strike_down")
				{
					skill.m.HD_StunDuration += 1;
				}
			}
		}
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		if (_bodyPart != ::Const.BodyPart.Head) return;
		if (!_targetEntity.isAlive()) return;
		if (_targetEntity.getCurrentProperties().IsImmuneToDaze) return;
		if (!this.isSkillValid(_skill)) return;

		local existingDazed = _targetEntity.getSkills().getSkillByID("effects.dazed");
		if (existingDazed == null)
		{
			local effect = ::new("scripts/skills/effects/dazed_effect");
			_targetEntity.getSkills().add(effect);
			effect.setTurns(this.m.HD_DazedDuration);

			local actor = this.getContainer().getActor();
			if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " has dazed " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for " + ::MSU.Text.colorPositive(this.m.HD_DazedDuration) + " turn(s)");
			}
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Mace)) return false;

		return true;
	}
});
