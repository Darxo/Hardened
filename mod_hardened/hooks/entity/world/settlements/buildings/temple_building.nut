
::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/temple_building", function(q) {
// Hardened Functions
	q.HD_onUpdateOtherShopList = @(__original) function( _id, _list )
	{
		switch (_id)
		{
			case "building.marketplace":
			{
				// Feat: Marketplaces now sometimes sell holy water, when a Temple exists in this town
				_list.push({
					R = 70,
					P = 1.0,
					S = "tools/holy_water_item",
				});
				_list.push({
					R = 70,
					P = 1.0,
					S = "tools/holy_water_item",
				});
			}
		}
	}
});
