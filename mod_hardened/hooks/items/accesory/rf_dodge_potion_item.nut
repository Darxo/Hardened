::Hardened.HooksMod.hook("scripts/items/accessory/rf_dodge_potion_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = this.m.Description = "A draught infused with the essence of spirits causes faint, shifting apparitions to trail the drinker, making it difficult for distant enemies to tell where the real body stands.";
	}
});
