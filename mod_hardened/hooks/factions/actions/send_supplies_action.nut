::Hardened.HooksMod.hook("scripts/factions/actions/send_supplies_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		// We switcheroo getProduce, so that vanilla doesnt add its wares items to the caravan. Instead we want to have control over them being added
		local start = (typeof this.m.Start == "instance" && this.m.Start instanceof ::WeakTableRef) ? this.m.Start.get() : this.m.Start;
		local oldGetProduce = start.getProduce;
		start.getProduce = function() { return [] };
		__original(_faction);
		start.getProduce = oldGetProduce;

		if (::MSU.isNull(this.m.Faction)) return;

		local lastSpawnedParty = this.m.Faction.m.HD_LastSpawnedParty;
		if (::MSU.isNull(lastSpawnedParty)) return;

		lastSpawnedParty.getSprite("banner").setOffset(::Hardened.Const.CaravanBannerOffset);

		// We now allow a customizable amount of trade goods. And we mark those trade goods in a special way, so that they drop in mint condition alter on
		if (start.getProduce().len() != 0)
		{
			for (local i = 0; i < this.HD_getProduceAmount(); ++i)
			{
				lastSpawnedParty.HD_addMintItemToInventory(::MSU.Array.rand(start.getProduce()));
			}
		}
	}

// New Functions
	q.HD_getProduceAmount <- function()
	{
		return ::Math.rand(2, 4);	// In Vanilla this is 2 - 4, but depending on on a scaling factor, which also influences challenge
	}
});

