this.scenario_hd_black_monolith <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Black Monolith";
		this.m.Description = "[p=c][img]gfx/ui/events/event_101.png[/img][/p]\n[p=c]The decision to enter the quarry rests heavy on your shoulders.[/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.UndeadTracks;
	}

// Hardened Functions
	function initMap()
	{
		local testMap = ::MapGen.get("tactical.quarry");
		local minX = testMap.getMinX();
		local minY = testMap.getMinY();
		::Tactical.resizeScene(minX, minY);
		testMap.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, null);
	}

	function initNPCs()
	{
		local blackMonolithLocation = ::new("scripts/entity/world/locations/legendary/black_monolith_location");
		blackMonolithLocation.location.onSpawned = function() {};

		local entities = [];
		local mockObject = ::Hardened.mockFunction(::Const.World.Common, "addTroop", function( _party, _troop, _updateStrength = true, _minibossify = 0 ) {
			local entity = clone _troop.Type;
			entity.Faction <- ::Const.Faction.Undead;
			entity.Variant = 0;
			entities.push(entity);
			return { value = null };
		});
		blackMonolithLocation.onSpawned();
		mockObject.cleanup();

		::Tactical.Entities.spawnEntitiesInFormation(entities, 1);
	}
});

