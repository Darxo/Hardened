::Hardened.HooksMod.hook("scripts/entity/world/settlements/city_state", function(q) {
	q.getProduce = @(__original) function()
	{
		local ret = __original();

		// We apply a consistent seed, so that multiple subsequent calls of this function provide the exact same result
		// This is important, because vanilla calls this multiple times for the same caravan generation in the style of
		//	> party.addToInventory(this.m.Start.getProduce()[::Math.rand(0, this.m.Start.getProduce().len() - 1)]);
		//	And we must guarantee that the returned array has the same size in both calls
		::Reforged.Math.seedRandom(
			"HD_FixedCityStateProduceSeed",	// Fixed salt, specific to use-case
			this.getName(),				// Town specific salt
			::World.getTime().Days		// Day specific salt
		);

		// Feat: City States now also "produce" ammo, armor parts and medicine, causing those items to appear in their trading caravans
		// Each only have a 50% to appear during each call, as we dont want them to take the spotlight
		if (::Math.rand(1, 2) == 1) ret.push("supplies/ammo_item");
		if (::Math.rand(1, 2) == 1) ret.push("supplies/armor_parts_item");
		if (::Math.rand(1, 2) == 1) ret.push("supplies/medicine_item");

		// We randomize the seed again, as we are done with its usage for our purpose. We dont want following random calls to be influenced too
		::Math.seedRandom(::Time.getRealTime());

		return ret;
	}
});
