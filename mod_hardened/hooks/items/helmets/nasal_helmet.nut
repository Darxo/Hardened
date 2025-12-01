::Hardened.HooksMod.hook("scripts/items/helmets/nasal_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		::Hardened.util.impersonateHelmet(this, "scripts/items/helmets/padded_nasal_helmet");
	}
});
