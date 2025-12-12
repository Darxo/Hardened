::Hardened.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
// Modular Vanilla Functions
	q.getBaseItemFields = @(__original) function()
	{
		local ret = __original();

		// We add our newly introduced fields here, so that they get copied over from the base weapon into its named version
		ret.push("AmmoWeight");

		return ret;
	}
});
