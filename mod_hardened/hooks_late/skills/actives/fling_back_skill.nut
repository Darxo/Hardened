::Hardened.HooksMod.hookTree("scripts/skills/actives/fling_back_skill", function(q) {
	// The Vanilla findTileToKnockBackTo of fling_back has a similar structure of all other functions but is implemented in reverse
	// Since we overwrite the "findTileToKnockBackTo" of all skills, we need to invert the arguments so it works in a backwards way for us
	q.findTileToKnockBackTo = @(__original) function( _userTile, _targetTile )
	{
		return __original(_targetTile, _userTile);
	}
});
