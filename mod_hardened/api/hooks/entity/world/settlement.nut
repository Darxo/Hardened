::Hardened.HooksMod.hook("scripts/entity/world/settlement", function(q) {
	q.setOwner = @(__original) function( _o )
	{
		__original(_o);

		local newBanner = _o.getBannerSmall();
		foreach (attached in this.m.AttachedLocations)
		{
			if (!attached.m.IsShowingBanner) continue;

			attached.setBanner(newBanner);
		}
	}

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
});
