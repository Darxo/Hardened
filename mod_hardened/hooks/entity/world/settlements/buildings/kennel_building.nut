::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/kennel_building", function(q) {
	q.m.HD_PriceMult <- 1.25;	// Vanilla: 0.75

	q.fillStash = @(__original) function( _list, _stash, _priceMult, _allowDamagedEquipment = false )
	{
		__original(_list, _stash, this.m.HD_PriceMult, _allowDamagedEquipment);
	}
});
