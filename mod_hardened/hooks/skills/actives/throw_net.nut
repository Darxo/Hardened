::Hardened.HooksMod.hook("scripts/skills/actives/throw_net", function(q) {
	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		// Switcheroo of BeastHuge so that we effectively disable the reforged condition where you cant net someone with a certain base reach
		local oldBeastHuge = ::Reforged.Reach.Default.BeastHuge;
		::Reforged.Reach.Default.BeastHuge = 9000;

		local ret = __original(_originTile, _targetTile);

		::Reforged.Reach.Default.BeastHuge = oldBeastHuge;
		return ret;
	}
});
