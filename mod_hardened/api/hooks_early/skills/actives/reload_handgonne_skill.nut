::Hardened.HooksMod.hook("scripts/skills/actives/reload_handgonne_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsRemovedAfterBattle = false;	// Vanilla: true
	}

	// Overwrite, because we disable the hard-coded vanilla action point cost set in here. Usually MV would already overwrite that, but we snipe MV's hook
	q.onAfterUpdate = @() { function onAfterUpdate( _properties )
	{
	}}.onAfterUpdate;

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
