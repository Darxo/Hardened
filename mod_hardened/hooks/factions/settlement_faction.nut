::Hardened.Temp.PlayerRelationReason <- null;

::Hardened.HooksMod.hook("scripts/factions/settlement_faction", function(q) {
	q.addPlayerRelation = @(__original) function( _relation, _reason = "" )
	{
		// We briefly fill ::Hardened.Temp.PlayerRelationReason with the reason for the relation change, so that we can mirror that reason for the owner
		::Hardened.Temp.PlayerRelationReason = _reason;
		__original(_relation, _reason);
		::Hardened.Temp.PlayerRelationReason = null;
	}

	q.getBanner = @(__original) function()
	{
		if (!::Tactical.isActive()) return __original();

		// While in combat, we return the banner of our owner instead. This fixes glitches, when Noble Troops spawn under a settlement faction and fail to apply their tabards
		local owner = this.getOwner();
		if (owner == null) return __original();

		return owner.getBanner();
	}
});
