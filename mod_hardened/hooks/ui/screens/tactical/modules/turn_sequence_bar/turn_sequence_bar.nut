::Hardened.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
	q.isRemovingEntity = @() function()	// This is called during battle
	{
		// If the delay is too long (like 2.0 in vanilla), then a players unleashed dog might skip a turn because someone dead during that time
		// If this function always returns false, then the game might freeze, when a goblin wolf rider dies while fleeing and spawning a wolf. Somehow that wolf will then not act anymore
		return this.m.LastRemoveTime + 0.25 >= ::Time.getRealTimeF();
	}

	q.convertEntityToUIData = @(__original) function( _entity, isLastEntity = false )
	{
		local ret = __original(_entity, isLastEntity);

		ret.moraleLabel = ret.morale;	// We remove any mention of offensive and defensive reach ignore

		return ret;
	}

	q.initNextRound = @(__original) function()
	{
		__original();

		if (!this.m.IsBattleEnded)
		{
			// Feat: Display in the combat log, whenever a new round starts
			::Tactical.EventLog.logEx("\n=== Round " + this.getCurrentRound() + " ===");
		}
	}

	if (::Hooks.hasMod("mod_extra_keybinds"))
	{
		// Extra Keybinds Fix: script error, when findEntityByID returns null
		// Extra Keybinds never checks, whether the return value is null
		q.ExtraKeybinds_onQueryEntityItemSwaps = @() function( _entityId )
		{
			local entityEntry = this.findEntityByID(this.m.CurrentEntities, _entityId);
			if (entityEntry == null) return null;

			local entity = entityEntry.entity;
			// The code below is a 1:1 copy of Extry Keybinds Code
			if (entity != null && entity.isPlayerControlled())
			{
				local items = entity.getItems().m.Items[::Const.ItemSlot.Bag]
				local ret = array(items.len());
				foreach (i, item in items) // can be null
				{
					if (item == null || item.getSlotType() == ::Const.ItemSlot.Bag) continue;
					local currentItem = entity.getItems().getItemAtSlot(item.getSlotType()) // can be null
					local blockedItem = entity.getItems().getItemAtSlot(item.getBlockedSlotType()) // can be null
					ret[i] = {
						id = item.getID(),
						idx = i,
						instanceId = item.getInstanceID(),
						imagePath = "ui/items/" + item.getIcon(),
						isUsable = item.isChangeableInBattle() && (currentItem == null || currentItem.isChangeableInBattle() && (blockedItem == null || blockedItem.isChangeableInBattle()))
						isAffordable = entity.getItems().isActionAffordable([currentItem, item, blockedItem])
					};
				}
				return ret;
			}
			return null;
		}
	}
});
