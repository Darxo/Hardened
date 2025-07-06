::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/building", function(q) {
	// Overwrite, because we completely re-implement this function, making it much more moddable in the process
	q.fillStash = @() function( _list, _stash, _priceMult, _allowDamagedEquipment = false )
	{
		_stash.clear();
		local rarityMult = this.getSettlement().getModifiers().RarityMult;
		local medicineRarityMult = this.getSettlement().getModifiers().MedicalPriceMult;
		local mineralRarityMult = this.getSettlement().getModifiers().MineralRarityMult;
		local buildingRarityMult = this.getSettlement().getModifiers().BuildingRarityMult;

		foreach (i in _list)
		{
			local rarityThreshold = i.R;

			// This RarityMult depends on situations and other effects that affect availability of certain item groups/types
			// A positive (> 1.0) multipliers will only take effect after the first item of that type was successfully spawned
			// Bad (< 1.0) multipliers will take affect immediately and can prevent items from being added in the first place
			local localRarityMult = rarityMult;

			// Maximum amount of items to be generated for this shop.
			// This starts at null because we don't know the maximum until we we instantiated the item
			// But for performance reason we don't instantiate items until it passes at least the first rarityThreshold
			local maximumItems = null;
			for (local generatedItems = 0; (maximumItems == null || generatedItems < maximumItems); ++generatedItems)
			{
				local roll = ::Math.rand(0, 100);
				if (roll * localRarityMult < rarityThreshold) break;	// We are done generating items

				local item = ::new("scripts/items/" + i.S);	// We only now instantiate the items for performance reasons

				if (maximumItems == null)	// When we are here, it means we entered the for loop for the first time, so we do some administrative tasks once
				{
					maximumItems = item.getShopAmountMax();	// Now that the item is actually generated, we fetch how many of it we should generate at most
					if (maximumItems == 0) break;	// There is a small chance that the item for some reason does not want to ever generate, so we respect that

					localRarityMult *= item.getRarityMult(this.getSettlement());

					// The first item was unaffected by localRarityMult, as it was still 1.0 by that time
					// So now we check in hindsight, whether the item would still be generated with the situations in mind
					if (roll * localRarityMult < rarityThreshold) break;
				}

				// The Item is decided to be added to the shop
				item.setPriceMult(i.P * _priceMult);
				_stash.add(item);

				rarityThreshold += roll;		// In Vanilla there are exceptions, sometimes the roll is not made harder (when Rarity is 0 to begin with and there are no bad rarityMults at play)

				// Damagable equipment might arrive damaged
				if (_allowDamagedEquipment && item.getConditionMax() > 1)
				{
					if (::Math.rand(1, 100) <= 50)
					{
						item.setCondition(::Math.rand(item.getConditionMax() * 0.4, item.getConditionMax()) * 1.0);
					}
				}
			}
		}

		_stash.sort();
	}

});
