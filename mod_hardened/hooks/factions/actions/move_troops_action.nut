::Hardened.HooksMod.hook("scripts/factions/actions/move_troops_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		// We do a switcheroo of Hardened.Global.WorldScalingBase, to briefly apply the noble difficulty bonus
		// That way, the noble troop spawned by this action will be affected by that multiplier
		local oldWorldScalingBase = ::Hardened.Global.WorldScalingBase;
		::Hardened.Global.WorldScalingBase *= ::Hardened.Global.FactionDifficulty.Nobles;
		local ret = __original(_faction);
		::Hardened.Global.WorldScalingBase = oldWorldScalingBase;

		return ret;
	}
});

