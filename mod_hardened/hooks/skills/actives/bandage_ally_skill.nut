::Hardened.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);
		_targetTile.getEntity().setDirty(true);	// Update the targets UI so that injuries are removed immediately
		return ret;
	}
});
