::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_supporter", function(q) {
// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_skill == null) return ret;

		if (_user.getID() == this.getContainer().getActor().getID())	// We must be the _user
		{
			if (this.isTargetValid(_skill, _target.getTile(), _target))
			{
				ret *= 2.0;	// We strongly prefer to use _skill on targets, where we would get action points back from this perk
			}
		}

		return ret;
	}

// New Functions
	// Determines whether using _skill on _targetTile/_targetEntity would cause this perk to procc and recover action points
	// Currently this is just a replica of the conditions that reforged uses in their supporter implementation
	q.isTargetValid <- function( _skill, _targetTile, _targetEntity = null )
	{
		if (this.m.IsSpent) return false;
		if (_targetEntity == null) return false;

		local actor = this.getContainer().getActor();
		if (actor.getID() == _targetEntity.getID()) return false;
		if (actor.getFaction() != _targetEntity.getFaction()) return false;
		if (!actor.isPlacedOnMap()) return false;
		if (actor.getTile().getDistanceTo(_targetTile) > this.m.MinDistanceAPRecovery) return false;

		return true;
	}
});
