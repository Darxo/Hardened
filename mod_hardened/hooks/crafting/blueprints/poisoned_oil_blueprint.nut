::Hardened.HooksMod.hook("scripts/crafting/blueprints/poisoned_oil_blueprint", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Sounds = ::Const.Sound.CraftingPotion;	// Vanilla: ::Const.Sound.CraftingGeneral
	}
});
