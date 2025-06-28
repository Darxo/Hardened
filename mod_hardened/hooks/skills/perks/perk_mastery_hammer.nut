// The reforged hook for this perk is being sniped
::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_hammer", function(q) {
	// Public
	q.m.ArmorDamageSpreadPct <- 0.5;	// This much of the initial armor damage is spread towards the other bodypart
	q.m.HD_FatigueCostMult <- 0.75;

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
			}
		}
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		// Spread some of the armor damage dealt to one of the bodyparts to the other
		if (_damageInflictedArmor != 0 && this.m.ArmorDamageSpreadPct != 0 && this.isEnabled() && this.isSkillValid(_skill) && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local newBodyPart = (_bodyPart == ::Const.BodyPart.Head) ? ::Const.BodyPart.Body : ::Const.BodyPart.Head;
			local armorDamageSpread = ::Math.floor(_damageInflictedArmor * this.m.ArmorDamageSpreadPct);

			local hitInfo = clone ::Const.Tactical.HitInfo;
			hitInfo.DamageArmor = armorDamageSpread;
			hitInfo.BodyPart = newBodyPart;

			_targetEntity.onDamageReceived(this.getContainer().getActor(), _skill, hitInfo);
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		return true;
	}

	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Hammer)) return false;

		return true;
	}
});
