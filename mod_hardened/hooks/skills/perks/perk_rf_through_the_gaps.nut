::Hardened.wipeClass("scripts/skills/perks/perk_rf_through_the_gaps", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_through_the_gaps", function(q) {
	// Public
	q.m.DirectDamageModifier <- 0.0;

	// Copy of reforged old through the gaps implementation
	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (!this.isSkillValid(_skill)) return;

		_properties.DamageDirectAdd += this.m.DirectDamageModifier;
		// This is a very ugly way to turn off the damage bonus against enemies, without accidentally dealing less than 100% damage
		// This method might breaks apart as soon as other mods try to implement effects that change this damage
		_properties.DamageAgainstMult[::Const.BodyPart.Head] = 1.0;

		if (_targetEntity != null)
		{
			local headArmor = _targetEntity.getArmor(::Const.BodyPart.Head);
			local bodyArmor = _targetEntity.getArmor(::Const.BodyPart.Body);
			if (headArmor < bodyArmor)
			{
				_properties.HitChance[::Const.BodyPart.Head] = 100.0;
				_properties.HitChanceMult[::Const.BodyPart.Body] = 0.0;
			}
			else if (bodyArmor < headArmor)
			{
				_properties.HitChance[::Const.BodyPart.Body] = 100.0;
				_properties.HitChanceMult[::Const.BodyPart.Head] = 0.0;
			}
		}
	}

// New Functions
	// Copy of reforged isSkillValid implementation
	q.isSkillValid <- function( _skill )
	{
		if (_skill.isRanged()) return false;
		if (!_skill.isAttack()) return false;

		if (this.m.RequiredWeaponType == null)
			return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
