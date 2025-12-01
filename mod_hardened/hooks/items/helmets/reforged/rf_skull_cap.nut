::Hardened.HooksMod.hook("scripts/items/helmets/rf_skull_cap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		::Hardened.util.impersonateHelmet(this, "scripts/items/helmets/rf_padded_skull_cap");
	}
});
