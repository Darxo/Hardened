::Hardened.HooksMod.hook("scripts/ai/tactical/behavior", function(q) {
	q.evaluate = @(__original) function( _entity )
	{
		local ret = __original(_entity);

		if (ret)
		{
			// We are only interested in behaviors, which control a certain skill use, which targets a certain tile at the end
			// Thankfully all of those vanilla implementations use this.m.Skill and this.m.TargetTile to store those results in
			if (this.m.Skill != null && this.m.TargetTile != null && this.m.TargetTile.getEntity() != null)
			{
				// Attacks are already covered by ModularVanillas hook of queryTargetValue
				// queryTargetValue seems to almost never be used for nonAttacks, so t
				// This will only manipulate the Score of the best target chosen by the behavior, it will not influence certain targets over others
				if (!this.m.Skill.isAttack())
				{
					local target = this.m.TargetTile.getEntity();
					this.m.Score *= _entity.getSkills().getQueryTargetValueMult(_entity, target, this.m.Skill) * target.getSkills().getQueryTargetValueMult(_entity, target, this.m.Skill);
				}
			}
		}

		return ret;
	}

	q.queryTargetValue = @(__original) function( _entity, _target, _skill = null )
	{
		local score = __original(_entity, _target, _skill);
		if (_skill != null)
		{
			local rebuke = _target.getSkills().getSkillByID("effects.hd_rebuke");
			if (rebuke != null && rebuke.m.ParentPerk != null && rebuke.m.ParentPerk.canProc(_entity, _skill))
			{
				score *= this.getProperties().TargetPriorityCounterSkillsMult;
			}
		}

		return ::Math.maxf(0.01, score);
	}
});
