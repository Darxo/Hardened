::Hardened.HooksMod.hook("scripts/entity/world/attached_location", function(q) {
	// Feat: Display the original location name for ruined
	q.getName = @() function()
	{
		return this.world_entity.getName() + (!this.isActive() ? " (Ruins)" : "");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local childrenElements = [];
		local childrenId = 41;
		foreach (produce in this.getProduceList())
		{
			local item = ::new("scripts/items/" + produce);
			childrenElements.push({
				id = childrenId,
				type = "text",
				icon = "ui/items/" + item.getIcon(),
				text = item.getName(),
			});
			++childrenId;
		}

		if (childrenElements.len() != 0)
		{
			ret.push({
				id = 40,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Produces:",
				children = childrenElements,
			});
		}

		return ret;
	}

	q.setActive = @(__original) function( _active )
	{
		// Feat: Attached Locations that get rebuilt, roll named items again
		if (!this.isActive() && _active && !::MSU.Serialization.isLoading())	// During deserialization, this is also called, so we need to ignore those calls
		{
			this.m.Loot.clear();	// First we clear the existing items/named items
			this.onSpawned();
		}

		__original(_active);
	}

// New Function
	q.getProduceList <- function()
	{
		local produceList = [];
		this.onUpdateProduce(produceList);
		return produceList;
	}
});
