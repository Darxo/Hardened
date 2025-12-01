::Hardened.HooksMod.hook("scripts/items/helmets/rf_scale_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		::Hardened.util.impersonateHelmet(this, "scripts/items/helmets/rf_padded_scale_helmet");
	}
});
