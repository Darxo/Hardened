::Hardened.HooksMod.hook("scripts/factions/actions/send_supplies_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		// We switcheroo getProduce, so that vanilla doesnt add its wares items to the caravan. Instead we want to have control over them being added
		local oldGetProduce = this.m.Start.getProduce;
		this.m.Start.getProduce = function() { return [] };
		__original(_faction);
		this.m.Start.getProduce = oldGetProduce;

		__original(_faction);

		local lastSpawnedParty = ::MSU.isNull(this.m.Faction) ? null : this.m.Faction.m.LastSpawnedParty;
		if (lastSpawnedParty != null)
		{
			lastSpawnedParty.getSprite("banner").setOffset(::Hardened.Const.CaravanBannerOffset);

			// We now allow a customizable amount of trade goods. And we mark those trade goods in a special way, so that they drop in mint condition alter on
			if (this.m.Start.getProduce().len() != 0)
			{
				for(local i = 0; i < this.HD_getProduceAmount(); ++i)
				{
					lastSpawnedParty.HD_addMintItemToInventory(::MSU.Array.rand(this.m.Start.getProduce()));
				}
			}
		}
	}

// New Functions
	q.HD_getProduceAmount <- function()
	{
		return ::Math.rand(2, 4);	// In Vanilla this is 2 - 4, but depending on on a scaling factor, which also influences challenge
	}
});

