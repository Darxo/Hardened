::Hardened.HooksMod.hook("scripts/skills/actives/gruesome_feast", function(q) {
	// Overwrite, because the Vanilla function is broken and never used. We only reimplement that function because we use it for AI calculations
	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;	// The Vanilla implementation will always return true, but a hook might change that
		if (!_originTile.isEqual(_targetTile)) return false;	// We must stand on top of the targeted tile
		if (!_targetTile.IsCorpseSpawned || _targetTile.Properties.get("Corpse").IsConsumable) return false;	// There must be a consumable corpse on the tile

		return true;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _target.getID()) return ret;		// We must be the target
		if (_target.getID() == _user.getID()) return ret;		// user and target must be different

		if (_target.isPlacedOnMap() && this.onVerifyTarget(_target.getTile(), _target.getTile()))	// gruesome feast is currently usable
		{
			// _user should try to kill us, if we stand on a consumable corpse. Even more urgently so, if we are almost dead and will otherwise heal back up
			// _user is always 10% more likely to target us in this case + 1% for each missing 1% hitpoints on us
			ret *= (2.1 - _target.getHitpointsPct());
		}

		return ret;
	}
});
