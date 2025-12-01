::Hardened.HooksMod.hook("scripts/items/helmets/kettle_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		::Hardened.util.impersonateHelmet(this, "scripts/items/helmets/padded_kettle_hat");
	}
});
