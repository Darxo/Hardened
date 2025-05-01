::Hardened.HooksMod.hook("scripts/ui/screens/character/character_screen", function(q) {
	q.m.DistributedXPFraction <- 0.5;
	q.m.MaximumXPFractionPerBrother <- 0.1;

	// Feat: when we equip arena collar, we imprint the previous item in them, so that it can be restored after the arena finished
	// This probably doesn't work, when we do the equipment via a swap initiatied by the already equipped item
	q.general_onEquipStashItem = @(__original) function( _data )
	{
		// First we fetch the source and target item of this equip action
		local oldData = this.helper_queryStashItemData(_data);
		if ("error" in oldData) return oldData;

		local sourceItem = oldData.sourceItem;
		local targetItem = this.helper_queryEquipmentTargetItems(oldData.inventory, sourceItem).firstItem;

		// Then we call the original
		local ret = __original( _data );

		if ("error" in ret) return ret;

		if (sourceItem.getID() == "accessory.arena_collar" && targetItem != null)		// We are about to swap an existing accessory with a collar
		{
			sourceItem.HD_savePreviousItem(oldData.inventory.getActor(), targetItem);
		}

		return ret;
	}

	q.onDismissCharacter = @(__original) function( _data )
	{
		local bro = ::Tactical.getEntityByID(_data[0]);
		if (bro == null) return __original();

		local payCompensation = _data[1];
		if (payCompensation)
		{
			::Hardened.util.shareExperience(bro.getXP() * this.m.DistributedXPFraction, this.m.MaximumXPFractionPerBrother, [bro.getID()]);
		}

		__original(_data);

	}
});
