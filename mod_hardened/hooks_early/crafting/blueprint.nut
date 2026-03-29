::Hardened.HooksMod.hookTree("scripts/crafting/blueprint", function(q) {
	// Overwrite, because we replace the core ingredient check from vanilla with a more performant one
	// Vanilla:
	// - For every existing recipe and every ingredient in that recipe: iterate the player inventory until we know if we have enough of that ingredient
	// Hardened:
	// - Iterate the player inventory once and build a table with all existing itemIDs and the amount of that item
	//	- For every existing recipe and every ingredient in that recipe: ask the table, if we have enough of that ingredient
	q.isCraftable = @() function()
	{
		foreach (ingredient in this.m.PreviewComponents)
		{
			if (!::World.Crafting.HD_hasItemAmount(ingredient.Instance.getID(), ingredient.Num))
			{
				return false;
			}
		}

		return true;
	}
});
