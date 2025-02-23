::Hardened.wipeClass("scripts/skills/perks/perk_rf_bear_down", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bear_down", function(q) {
	// Public
	q.m.DazedDuration <- 1;

	q.onTargetHit <- function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_bodyPart != ::Const.BodyPart.Head) return;
		if (!_targetEntity.isAlive() || _targetEntity.isDying()) return;
		if (!this.isSkillValid(_skill)) return;

		local existingDazed = _targetEntity.getSkills().getSkillByID("effects.dazed");
		if (existingDazed == null)
		{
			if (_targetEntity.getCurrentProperties().IsImmuneToDaze) return;

			local effect = ::new("scripts/skills/effects/dazed_effect");
			_targetEntity.getSkills().add(effect);
			effect.setTurns(1);

			local actor = this.getContainer().getActor();
			if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " has dazed " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for " + ::MSU.Text.colorPositive(this.m.DazedDuration) + " turn(s)");
			}
		}
		else
		{
			existingDazed.setTurns(existingDazed.m.TurnsLeft + this.m.DazedDuration);
			this.spawnIcon("status_effect_87", _targetEntity.getTile());
		}
	}

// Reforged Functions
	q.isSkillValid <- function( _skill )
	{
		if (!_skill.isAttack()) return false;

		if (this.m.RequiredWeaponType == null) return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
