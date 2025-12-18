::Hardened.HooksMod.hook("scripts/items/accessory/special/arena_collar_item", function(q) {
	// Private
	q.m.HD_RestoreItemIDFlag <- "HD_RestoreItemIDFlag";
	q.m.HD_RestoreBrotherUIDFlag <- "HD_RestoreBrotherUIDFlag";

// New Functions
	q.HD_savePreviousItem <- function( _owner, _previousItem )
	{
		if (_previousItem.getID() == "accessory.arena_collar")	// We replace an existing collor with a new one (complicated case)
		{
			// We adopt the restore properties of the target collor and delete its memory. But only if that collar has any memory about restoration
			if (_previousItem.getFlags().has(_previousItem.m.HD_RestoreItemIDFlag))
			{
				this.getFlags().set(this.m.HD_RestoreItemIDFlag, _previousItem.getFlags().get(this.m.HD_RestoreItemIDFlag));
				_previousItem.getFlags().remove(_previousItem.m.HD_RestoreItemIDFlag);
				_previousItem.getFlags().remove(_previousItem.m.HD_RestoreBrotherUIDFlag);
			}
		}
		else
		{
			this.getFlags().set(this.m.HD_RestoreItemIDFlag, _previousItem.getID());
		}

		this.getFlags().set(this.m.HD_RestoreBrotherUIDFlag, _owner.getUID());
	}

	// Reequip the item saved in our restore flag, if it still exists in the inventory
	// Does nothing if we have no information about any restoration
	q.HD_reequipPreviousItem <- function()
	{
		// If we have no restore flags, we do no restoration
		if (!this.getFlags().has(this.m.HD_RestoreItemIDFlag)) return;

		local stash = ::World.Assets.getStash();

		local targetUID = this.getFlags().get(this.m.HD_RestoreBrotherUIDFlag);
		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			if (bro.getUID() != targetUID) continue;

			local targetItemID = this.getFlags().get(this.m.HD_RestoreItemIDFlag);
			foreach (item in stash.getItems())
			{
				if (item == null) continue;
				if (item.getID() != targetItemID) continue;

				if (bro.getItems().equip(item))	// We equip the first fitting item. That might not be exactly the one, which we had on previously
				{
					stash.remove(item);
				}
				break;
			}

			break;
		}
	}
});

