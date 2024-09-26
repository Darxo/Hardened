::Hardened.HooksMod.hook("scripts/factions/faction", function(q) {
	// Private
	q.m.LastSpawnedParty <- null;	// weakref to the last party, spawned by this factions spawnEntity function

	q.spawnEntity = @(__original) function( _tile, _name, _uniqueName, _template, _resources )
	{
		local ret = __original(_tile, _name, _uniqueName, _template, _resources);

		// We spawn a very short wait order on any newly created party. Fixes Vanilla bug of teleporting any parties which will instantly engage player in battle
		local waitOrder = ::new("scripts/ai/world/orders/wait_order");
		waitOrder.setTime(1);	// About 14 ingame minutes
		ret.getController().addOrder(waitOrder);

		this.m.LastSpawnedParty <- ::MSU.asWeakTableRef(ret);

		return ret;
	}
});
