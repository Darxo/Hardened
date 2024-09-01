::Hardened.HooksMod.hook("scripts/events/events/dlc4/location/tundra_elk_destroyed_event", function(q) {
	q.create = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "A" || screen.ID == "B")
			{
				local oldStart = screen.start
				screen.start = function( _event )
				{
					oldStart(_event);
					::World.Assets.getStash().makeEmptySlots(1);
					local item = ::new("scripts/items/special/legendary_sword_blade_item");	// This is the same item that's granted by the kraken kill
					::World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + ::Const.Strings.getArticle(item.getName()) + item.getName(),
					});
				}
			}
		}
	}
});
