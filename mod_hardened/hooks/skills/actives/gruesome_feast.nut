::Hardened.HooksMod.hook("scripts/skills/actives/gruesome_feast", function(q) {
	// Overwrite, because the Vanilla function is broken and never used. We only reimplement that function because we use it for AI calculations
	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;	// The Vanilla implementation will always return true, but a hook might change that
		if (!_originTile.isEqual(_targetTile)) return false;	// We must stand on top of the targeted tile
		if (!_targetTile.IsCorpseSpawned || _targetTile.Properties.get("Corpse").IsConsumable) return false;	// There must be a consumable corpse on the tile

		return true;
	}

// Hardened Functions
	// If _user is evaluating our value, potentially targeting us with _usedSkill, how would that change our perceived value for them?
	// This code was verified working with debug logs and a dog triggering it
	q.getQueryTargetMultAsTarget = @(__original) function( _user, _usedSkill = null )
	{
		local ret = __original(_user, _usedSkill);

		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return ret;

		if (this.onVerifyTarget(actor.getTile(), actor.getTile()))
		{
			// _user should try to kill us, if we stand on a consumable corpse. Even more urgently so, if we are almost dead and will otherwise heal back up
			// _user is always 10% more likely to target us in this case + 1% for each missing 1% hitpoints on us
			ret *= (2.1 - this.getContainer().getActor().getHitpointsPct());
		}

		return ret;
	}
});
