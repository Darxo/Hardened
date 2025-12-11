::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_flail_spinner", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Chance = 100;
	}

	q.doSpinAttack = @(__original) function( _skill, _user, _targetEntity, _targetTile )
	{
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

		if (potentialTargets.len() != 0)
		{
			__original(_skill, _user, _targetEntity, ::MSU.Array.rand(potentialTargets));
		}
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
