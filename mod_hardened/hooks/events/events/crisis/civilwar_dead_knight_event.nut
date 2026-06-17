::Hardened.HooksMod.hook("scripts/events/events/crisis/civilwar_dead_knight_event", function(q) {
	q.create = @(__original) function()
	{
		__original();

		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "A")
			{
				// Feat: This event now spawns a regular Full Helm, instead of a
				screen.start = function( _event ) {
					local item = ::new("scripts/items/helmets/full_helm");
					item.setCondition(27.0);
					::World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "You gain " + ::Const.Strings.getArticle(item.getName()) + item.getName(),
					});
				};
			}
		}
	}
});
