::Hardened.HooksMod.hookTree("scripts/crafting/blueprint", function(q) {
	q.create = @(__original) function()
	{
		__original();

		if (this.m.PreviewCraftable.getID() == "misc.snake_oil")
		{
			this.m.Sounds = ::Const.Sound.CraftingPotion;	// Vanilla: ::Const.Sound.CraftingGeneral
		}
		else if (this.m.ID.find("potion") != null || this.m.ID.find("elixir") != null)
		{
			this.m.Sounds = ::Const.Sound.CraftingPotion;	// Vanilla: ::Const.Sound.CraftingGeneral
		}
	}
});
