::Hardened.HooksMod.hook("scripts/skills/actives/sleep_skill", function(q) {
	// Sleep can no longer be used on headless entities
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return __original(_originTile, _targetTile) && !_targetTile.getEntity().getSkills().hasSkill("effects.hd_headless");
	}
});
