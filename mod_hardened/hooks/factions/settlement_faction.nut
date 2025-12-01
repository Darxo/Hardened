::Hardened.HooksMod.hook("scripts/factions/settlement_faction", function(q) {
	q.getBanner = @(__original) function()
	{
		if (!::Tactical.isActive()) return __original();

		// While in combat, we return the banner of our owner instead. This fixes glitches, when Noble Troops spawn under a settlement faction and fail to apply their tabards
		local owner = this.getOwner();
		if (owner == null) return __original();

		return owner.getBanner();
	}
});
