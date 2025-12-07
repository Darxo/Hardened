::Hardened.HooksMod.hook("scripts/crafting/blueprints/night_vision_elixir_blueprint", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Sounds = ::Const.Sound.CraftingPotion;	// Vanilla: ::Const.Sound.CraftingGeneral
	}
});
