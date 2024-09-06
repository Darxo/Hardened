::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_axe", function(q) {
	q.onAnySkillExecuted = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		__original(_skill, _targetTile, _targetEntity, _forFree);
		if (_skill.getID() == "actives.split_shield" && !_targetEntity.getSkills().hasSkill("effects.dazed"))
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
});
