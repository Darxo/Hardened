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
			local item = this.new("scripts/items/" + produce);
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

// New Function
	q.getProduceList <- function()
	{
		local produceList = [];
		this.onUpdateProduce(produceList);
		return produceList;
	}
});
