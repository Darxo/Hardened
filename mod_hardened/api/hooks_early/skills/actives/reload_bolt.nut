::Hardened.HooksMod.hook("scripts/skills/actives/reload_bolt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsRemovedAfterBattle = false;	// Vanilla: true
	}

	// Overwrite, because we improve the usability logic
	q.isUsable = @() function()
	{
		if (!this.skill.isUsable()) return false;
		if (::MSU.isNull(this.getItem())) return false;		// Ideally a reload skill should always be attached to its weapon, but Vanilla or a mod may add it disconnected too
		if (!this.getItem().HD_canBeLoaded()) return false;		// We now use the new weapon utility function instead of checking the ammo count manually

		local actor = this.getContainer().getActor();
		return actor.isPlacedOnMap() && !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions());
	}

	// Overwrite, because we prevent it from removing itself
	q.onUse = @() function( _user, _targetTile )
	{
		this.getItem().HD_tryReload();
		return true;
	}
});
