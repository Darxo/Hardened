::Hardened.HooksMod.hook("scripts/factions/actions/send_citystate_army_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		// We do a switcheroo of Hardened.Global.WorldScalingBase, to briefly apply the CityState difficulty bonus
		// That way, the southern troop spawned by this action will be affected by that multiplier
		local oldWorldScalingBase = ::Hardened.Global.WorldScalingBase;
		::Hardened.Global.WorldScalingBase *= ::Hardened.Global.FactionDifficulty.CityState;
		local ret = __original(_faction);
		::Hardened.Global.WorldScalingBase = oldWorldScalingBase;

		return ret;
	}
});

