::Hardened.HooksMod.hook("scripts/mapgen/templates/tactical/patches/patch_forest", function(q) {
	q.fill = @(__original) function( _rect, _properties, _pass = 1 )
	{
		// Feat: forest maps no longer randomly (5% chance) spawn grass tiles
		// Those tiles just randomly screw decision making, where usually all tiles require 3 AP to traverse
		local mockObject = ::Hardened.mockFunction(::MapGen, "get", function( _tileName ) {
			if (_tileName == "tactical.tile.grass1")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
			{
				return { done = true, value = ::MapGen.get("tactical.tile.moss1") };
			}
		});

		__original(_rect, _properties, _pass);
		mockObject.cleanup();
	}
});
