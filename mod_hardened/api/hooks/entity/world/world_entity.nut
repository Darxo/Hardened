::Hardened.HooksMod.hook("scripts/entity/world/world_entity", function(q) {
	// Private
	q.m.HD_MintConditionItems <- [];
	q.m.HD_MintConditionFlag <- "HD_MintConditionFlag";
	q.m.HD_IsTemporaryUnallied <- false;	// While true, isAlliedWithPlayer will always return false; Can be used to force a troop tooltip on neutral locations

// New Functions
	// @return an integer representing the last number in this parties player banner brush
	// @return -1 if no player banner brush could be found
	q.getBannerID <- function()
	{
		if (this.hasSprite("banner"))
		{
			local bannerSprite = this.getSprite("banner");
			if (bannerSprite.HasBrush)
			{
				local stringIndex = bannerSprite.getBrush().Name.find("banner_");
				try {	// Non-player banner used here will throw errors
					return bannerSprite.getBrush().Name.slice(stringIndex + 7).tointeger();	// +7 because "banner_" are 7 characters and we wanna point to the first character after this
				}
				catch (err) {}	// Do nothing
			}
		}
		return -1;
	}

	q.isAlliedWithPlayer = @(__original) function()
	{
		if (this.m.HD_IsTemporaryUnallied) return false;

		return __original();
	}

	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		this.HD_onDropMintConditionLoot(_lootTable);
		__original(_lootTable);
	}

	q.onSerialize = @(__original) function( _out )
	{
		local mintConditionString = "";
		foreach (mintItem in this.m.HD_MintConditionItems)
		{
			mintConditionString += mintItem + ";";
		}

		this.getFlags().set(this.m.HD_MintConditionFlag, mintConditionString);

		__original(_out);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		if (this.getFlags().has(this.m.HD_MintConditionFlag))
		{
			foreach (mintItem in split(this.getFlags().get(this.m.HD_MintConditionFlag), ";"))
			{
				this.m.HD_MintConditionItems.push(mintItem);
			}
		}
	}

// New Functions
	q.HD_addMintItemToInventory <- function( _mintItemPath )
	{
		this.m.HD_MintConditionItems.push(_mintItemPath);
		this.addToInventory(_mintItemPath);
	}

	// Drop all "mint condition" items from this.m.Inventory into _lootTable, which also appear in this.m.HD_MintConditionItems
	// Dropping them at "mint condition" means at full condition/stack/freshness. Then remove those items from both arrays
	q.HD_onDropMintConditionLoot <- function( _lootTable )
	{
		for (local index = this.m.Inventory.len() - 1; index >= 0; --index)
		{
			local itemPath = this.m.Inventory[index];

			foreach (jndex, mintItem in this.m.HD_MintConditionItems)
			{
				if (itemPath == mintItem)
				{
					local item = ::new("scripts/items/" + itemPath);
					_lootTable.push(item);

					this.m.HD_MintConditionItems.remove(jndex);
					this.m.Inventory.remove(index);
					break;
				}
			}
		}
	}

	q.HD_dropFood <- function( _num, _items, _lootTable, _minServingPct = 0.0, _minGoodForPct = 0.0 )
	{
		_num = this.Math.max(0, this.Math.round(_num * this.m.LootScale));

		if (_num == 0)
		{
			return;
		}

		for (local i = 0; i != _num; ++i)
		{
			local food = ::new("scripts/items/supplies/" + ::MSU.Array.rand(_items));

			local minAmount = ::Math.max(1, food.m.HD_MaxAmount * _minServingPct);
			food.m.Amount = ::Math.rand(minAmount, food.m.HD_MaxAmount);

			local minGoodFor = ::Math.max(1, food.m.GoodForDays * _minGoodForPct);
			if (("State" in ::World) && ::World.State != null && ::World.State.getCombatStartTime() != 0)
			{
				food.m.BestBefore = ::World.State.getCombatStartTime() + ::Math.rand(minGoodFor, food.m.GoodForDays) * ::World.getTime().SecondsPerDay;
			}
			else
			{
				food.m.BestBefore = ::Time.getVirtualTimeF() + ::Math.rand(minGoodFor, food.m.GoodForDays) * ::World.getTime().SecondsPerDay;
			}

			_lootTable.push(food);
		}
	}
});
