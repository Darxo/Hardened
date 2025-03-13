::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_hammer", function(q) {
	// Public
	q.m.ArmorDamageSpreadPct <- 0.5;	// This much of the initial armor damage is spread towards the other bodypart

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
		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Hammer);
	}
});
