::Hardened.HooksMod.hook("scripts/entity/world/settlement", function(q) {
	q.m.HD_OwnContractChance <- 1.0;
	q.m.HD_OwnContractsMax <- 99;
	q.m.HD_ForeignContractChance <- 1.0;	// Chance per contract from the owning faction to have it appear in this settlement (seeded). 1.0 Means that all contracts appear
	q.m.HD_ForeignContractsMax <- 99;	// Maximum contracts from the owner faction able to appear at the same time in this settlement

	q.setOwner = @(__original) function( _o )
	{
		__original(_o);

		local newBanner = _o.getBannerSmall();
		foreach (attached in this.m.AttachedLocations)
		{
			attached.setBanner(newBanner);
		}
	}

	q.getContracts = @(__original) { function getContracts()
	{
		local ret = [];

		local ownContractsAdded = 0;
		local foreignContractsAdded = 0;
		foreach (contract in __original())
		{
			if (contract.getFaction() == this.getFaction())
			{
				if (contract.isStarted())
				{
					++ownContractsAdded;
					ret.push(contract);
					continue;
				}

				// Feat: Enforce custom HD_OwnContractsMax
				if (ownContractsAdded >= this.m.HD_OwnContractsMax) continue;

				// Feat: Enforce random and seeded HD_OwnContractChance
				::Reforged.Math.seedRandom(
					"HD_FixedContractChanceSeed",	// Fixed salt, specific to use-case
					contract.getID(),
					this.getName(),			// world entity specific salt
					this.getFaction(),			// Faction specific salt
					this.getTile().X * 200,	// Position specific salt
					this.getTile().Y			// Position specific salt
				);
				if (::MSU.Math.randf(0.0, 1.0) <= this.m.HD_OwnContractChance)
				{
					++ownContractsAdded;
					ret.push(contract);
				}
			}
			else
			{
				if (contract.isStarted())
				{
					++foreignContractsAdded;
					ret.push(contract);
					continue;
				}

				// Feat: Enforce custom HD_ForeignContractsMax
				if (foreignContractsAdded >= this.m.HD_ForeignContractsMax) continue;

				// Feat: Enforce random and seeded HD_ForeignContractChance
				::Reforged.Math.seedRandom(
					"HD_FixedContractChanceSeed",	// Fixed salt, specific to use-case
					contract.getID(),
					this.getName(),			// world entity specific salt
					this.getFaction(),			// Faction specific salt
					this.getTile().X * 200,	// Position specific salt
					this.getTile().Y			// Position specific salt
				);

				if (::MSU.Math.randf(0.0, 1.0) <= this.m.HD_ForeignContractChance)
				{
					++foreignContractsAdded;
					ret.push(contract);
				}
			}
		}

		return ret;
	}}.getContracts;

	// Overwrite, because we make the impact of positive and negative relation moddable
	q.getBuyPriceMult = @() function()
	{
		local priceMult = this.getPriceMult() * ::World.Assets.getBuyPriceMult();
		priceMult *= 1.0 + -::World.FactionManager.getFaction(this.m.Factions[0]).HD_getRelationPricePct();
		priceMult *= this.m.Modifiers.BuyPriceMult;
		return priceMult;
	}

	// Overwrite, because we make the impact of positive and negative relation moddable
	q.getSellPriceMult = @() function()
	{
		local priceMult = this.getPriceMult() * ::World.Assets.getSellPriceMult();
		priceMult *= 1.0 + ::World.FactionManager.getFaction(this.m.Factions[0]).HD_getRelationPricePct();
		priceMult *= this.m.Modifiers.SellPriceMult;
		return priceMult;
	}

	q.onUpdateShopList = @(__original) function( _id, _list )
	{
		__original(_id, _list);

		// Feat: shoplists of one building can now be influenced by other existing buildings
		foreach (building in this.HD_getBuildings())
		{
			building.HD_onUpdateOtherShopList(_id, _list);
		}
	}

// New Functions
	q.HD_getBuildings <- function()
	{
		local ret = [];
		foreach (building in this.m.Buildings)
		{
			if (building != null) ret.push(building);
		}
		return ret;
	}
});
