::Hardened.HooksMod.hook("scripts/skills/actives/insects_skill", function(q) {
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return __original(_originTile, _targetTile) && !_targetTile.getEntity().getSkills().hasSkill("effects.hd_headless");
	}
});
