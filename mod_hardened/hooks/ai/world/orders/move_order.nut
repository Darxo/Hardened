::Hardened.HooksMod.hook("scripts/ai/world/orders/move_order", function(q) {
	// Overwrite, because cant implement our changes otherwise as they rely on the deserialized values
	q.onDeserialize = @() function( _in )
	{
		this.world_behavior.onDeserialize(_in);
		local x = _in.readI16();
		local y = _in.readI16();

		// Vanilla Fix: Caravans rarely despawning when loading a save
		// Vanilla also checks for y != -1, but that check is not required and will result in false positives
		// Negative y coordinates on world tiles actually happen on ~20% of all tiles. So naturally a destination can have a -1,
		//	which vanilla misinterprets into setting TargetTile to null
		if (x != -1)
		{
			this.m.TargetTile = ::World.getTile(x, y);
		}

		this.m.RoadsOnly = _in.readBool();
		this.m.AvoidSettlements = _in.readBool();
	}

// Hardened Events
	q.HD_onRemoved = @(__original) function()
	{
		__original();

		local party = this.getController().getEntity();
		if (party.getFlags().has("HD_IsBountyHunters"))
		{
			foreach (worldEntity in ::World.getAllEntitiesAtPos(party.getPos(), 100))
			{
				if (!worldEntity.isLocation()) continue;
				if (!worldEntity.isLocationType(::Const.World.LocationType.Settlement)) continue;

				if (worldEntity.getFactions().len() == 1)
				{
					party.setFaction(worldEntity.getOwner().getID());
				}
				else
				{
					party.setFaction(worldEntity.getFactionOfType(::Const.FactionType.Settlement).getID());
				}
				break;
			}
		}
	}
});
