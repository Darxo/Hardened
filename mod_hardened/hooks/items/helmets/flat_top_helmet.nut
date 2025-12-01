::Hardened.HooksMod.hook("scripts/items/helmets/flat_top_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		::Hardened.util.impersonateHelmet(this, "scripts/items/helmets/padded_flat_top_helmet");
	}
});
