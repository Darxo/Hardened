::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_swallow_whole", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		// We allow nachzehrer to consider swalling even if that is the last enemy they know of by tricking vanilla in always thinking there are 2 known enemies in this situation
		local mockObject = ::Hardened.mockFunction(this.getAgent(), "getKnownOpponents", function() {
			if (::Hardened.getFunctionCaller(1) == "onEvaluate")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
			{
				local dummyPlayer = ::MSU.getDummyPlayer();	// The dummy player is by default from the player faction, so it is ideal for our use here

				// The important thing here is that the returned array has 2 tables with an Array which is a weakref to a player controlled character
				return { done = false, value = [{Actor = ::MSU.asWeakTableRef(dummyPlayer)}, {Actor = ::MSU.asWeakTableRef(dummyPlayer)}] };
			}
		});

		local ret = __original(_entity);
		mockObject.cleanup();	// It is very likely that our mock function was never called, so we must clean up now
		return ret;
	}

	// Overwrite, because there is no way to otherwise the usage of queryTargetValue
	q.getBestTarget = @() function( _entity, _skill, _targets )
	{
		local bestTarget;
		local bestScore = 0.0;
		foreach( target in _targets )
		{
			if (!_skill.onVerifyTarget(_entity.getTile(), target.getTile())) continue;
			if (target.getHitpoints() <= 10) continue;

			local score = 0.0;
			local p = target.getCurrentProperties();
			score += p.getMeleeDefense();
			score += p.getMeleeSkill() * 0.25;
			score += target.getHitpoints() * 0.25;
			score += (target.getArmor(::Const.BodyPart.Body) * (p.HitChance[::Const.BodyPart.Body] / 100.0) + target.getArmor(::Const.BodyPart.Head) * (p.HitChance[::Const.BodyPart.Head] / 100.0)) * 0.1;
			// Feat: We now call queryTargetValue instead of just multiplying with TargetAttractionMult
			score *= this.queryTargetValue(_entity, target, this.m.Skill);

			if (score > bestScore)
			{
				bestTarget = target;
				bestScore = score;
			}
		}

		return {
			Target = bestTarget,
			Score = bestScore * 0.01
		};
	}
});
