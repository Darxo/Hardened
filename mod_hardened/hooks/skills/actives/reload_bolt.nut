::Hardened.HooksMod.hook("scripts/skills/actives/reload_bolt", function(q) {
	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);
		this.getContainer().add(::new("scripts/skills/effects/hd_reload_disorientation_effect"));
		return ret;
	}
});
