::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_axe", function(q) {
	// Public
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

	q.onAnySkillExecuted = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		__original(_skill, _targetTile, _targetEntity, _forFree);
		if (_skill.getID() == "actives.split_shield" && !_targetEntity.getCurrentProperties().IsImmuneToDaze && !_targetEntity.getSkills().hasSkill("effects.dazed"))
		{
			local effect = ::new("scripts/skills/effects/dazed_effect");
			_targetEntity.getSkills().add(effect);
			effect.setTurns(1);
			local actor = this.getContainer().getActor();
			if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " struck " + ::Const.UI.getColorizedEntityName(_targetEntity) + "\'s shield, leaving them dazed");
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
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Axe)) return false;

		return true;
	}
});
