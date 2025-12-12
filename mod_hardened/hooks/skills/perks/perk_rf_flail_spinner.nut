::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_flail_spinner", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Chance = 100;
	}

	q.onAnySkillExecutedFully = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		// We check for these conditions for performance reasons, as we assume the checking for potential alternatives takes more time
		if (_forFree || ::MSU.isEqual(_skill, this.m.__SpinningWithSkill) || !this.isSkillValid(_skill))
		{
			return __original(_skill, _targetTile, _targetEntity, _forFree);
		}

		// Reforged checks, whether the _targetEntity is alive, after the skill execution and stops any spinning attempt in that case
		// We however dont care about the _targetEntity, because we target a different entity, so we pretent to Reforged, like _targetEntity was actually the new target
		local potentialTargets = [];
		local actor = this.getContainer().getActor();

		local potentialEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 2, false);
		foreach (enemy in potentialEnemies)
		{
			local tileToCheck = enemy.getTile();
			if (tileToCheck.ID == _targetTile.ID) continue;	// We don't allow this perk to hit the same entity again

			if (this.__isUsableOn(_skill, actor.getTile(), tileToCheck))
			{
				potentialTargets.push(tileToCheck);
			}
		}
		if (potentialTargets.len() == 0) return;	// We want nothing to happen

		// We pretend to the reforged flail spinner, that we targeted something else all along, so that they then try to spin the flail on that target
		local targetTile = ::MSU.Array.rand(potentialTargets);
		__original(_skill, targetTile, targetTile.getEntity(), _forFree);
	}

// New Functions
	q.__isUsableOn <- function( _skill, _userTile, _targetTile )	// custom implementation of this skill.nut function which assumes the skill will be used for free
	{
		if (_skill.m.IsVisibleTileNeeded && !_targetTile.IsVisibleForEntity)
		{
			return false;
		}

		if (!_skill.onVerifyTarget(_userTile, _targetTile))
		{
			return false;
		}

		local d = _userTile.getDistanceTo(_targetTile);

		if (d < _skill.getMinRange() || d > _skill.getMaxRange())
		{
			return false;
		}

		return true;
	}
});
