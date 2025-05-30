this.hd_bag_item_manager <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		BagSlotsMax = ::Const.ItemSlotSpaces[::Const.ItemSlot.Bag],

		// Private
		BagSlotsMin = 0,
	},

	function create()
	{
		this.m.ID = "special.hd_bag_item_manager";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = ::Const.SkillType.Special;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onAfterUpdate( _properties )
	{
		// We skip changes during loading as the bag_item_manager is added very early during serialization
		// and will be part of many updates before the bag adjusting perks are deserialized
		if (::MSU.Serialization.isLoading()) return;

		local items = this.getContainer().getActor().getItems();

		local oldBagSlots = items.getUnlockedBagSlots();
		local newBagSlots = ::Math.clamp(_properties.BagSlots, this.m.BagSlotsMin, this.m.BagSlotsMax);

		if (newBagSlots < oldBagSlots)		// Do we have less space now than before?
		{
			// Since recoverBagItems requires indices, we can pass newBagSlots just like that and have to subtract 1 from BagSlotsMax
			this.recoverBagItems(newBagSlots, this.m.BagSlotsMax - 1)
		}

		items.setUnlockedBagSlots(newBagSlots);
	}

// New Functions
	// Remove all bag items from _indexMin to _indexMax and add them to the player stash
	function recoverBagItems( _indexMin, _indexMax )
	{
		local items = this.getContainer().getActor().getItems();
		for (local i = _indexMin; i <= _indexMax; ++i)
		{
			local item = items.getItemAtBagSlot(i);
			if (item == null) continue;
			items.removeFromBag(item);
			::World.Assets.getStash().add(item);
			// Todo: add logic for dropping this to the ground, when it happens during combat?
		}
	}
});
