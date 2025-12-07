::Hardened.HooksMod.hook("scripts/crafting/blueprints/antidote_blueprint", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Cost = 25;	// In Vanilla this is 50
		this.m.PreviewComponents[0].Num = 1;	// In Vanilla this costs 2 Jagged Fangs
		this.m.Sounds = ::Const.Sound.CraftingPotion;	// Vanilla: ::Const.Sound.CraftingGeneral
	}
});
