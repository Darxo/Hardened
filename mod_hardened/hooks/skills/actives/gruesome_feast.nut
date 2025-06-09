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

		if (!_target.isPlacedOnMap()) return ret;

		local isAllied = _user.isAlliedWith(_target);
		local standingOnAConsumableCorpse = this.onVerifyTarget(_target.getTile(), _target.getTile());	// gruesome feast is currently usable
		if (standingOnAConsumableCorpse && !isAllied)
		{
			// _user should try to kill us, if we stand on a consumable corpse. Even more urgently so, if we are almost dead and will otherwise heal back up
			// _user is always 10% more likely to target us in this case + 1% for each missing 1% hitpoints on us
			ret *= (2.1 - _target.getHitpointsPct());
		}

		local skillsThatSwitchEntities = [
			"actives.barbarian_fury",
			"actives.rotation",
			"actives.rf_dynamic_duo_shuffle",
			"actives.rf_swordmaster_tackle",
		];

		if (_skill != null && _target.getMoraleState() != ::Const.MoraleState.Fleeing)
		{
			local userStandingOnConsumableCorpse = this.onVerifyTarget(_user.getTile(), _user.getTile());
			if (standingOnAConsumableCorpse != userStandingOnConsumableCorpse) return ret;	// If neither tile or both tile have corpses, we don't care

			if (skillsThatSwitchEntities.find(_skill.getID()) != null)
			{
				if (isAllied && userStandingOnConsumableCorpse) ret *= 2.0;
				if (!isAllied && userStandingOnConsumableCorpse) ret *= 0.5;
			}
		}

		return ret;
	}
});
