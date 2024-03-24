::Hardened.HooksMod.hook("scripts/items/accessory/accessory", function(q) {
	// This function from item.nut is not implemented for this class. This is meant as a default so that every accessory has at least a sound when moved
	q.playInventorySound = @() function( _eventType )
	{
		::Sound.play("sounds/combat/armor_leather_impact_03.wav", ::Const.Sound.Volume.Inventory);
	}
});

