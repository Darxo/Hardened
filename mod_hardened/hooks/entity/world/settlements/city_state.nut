::Hardened.HooksMod.hook("scripts/entity/world/settlements/city_state", function(q) {
	q.getProduce = @(__original) function()
	{
		local ret = __original();

		// Feat: City States now also "produce" ammo, armor parts and medicine, causing those items to appear in their trading caravans
		// Each only have a 50% to appear during each call, as we dont want them to take the spotlight
		if (::Math.rand(1, 2) == 1) ret.push("supplies/ammo_item");
		if (::Math.rand(1, 2) == 1) ret.push("supplies/armor_parts_item");
		if (::Math.rand(1, 2) == 1) ret.push("supplies/medicine_item");

		return ret;
	}
});
