this.scenario_hd_goblin_city <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Goblin City";
		this.m.Description = "[p=c][img]gfx/ui/events/event_119.png[/img][/p]\n[p=c]A great goblin city nested into the remains of an ancient fortress. Protected by dark and towering walls, it is host to a standing army of vicious greenskins.[/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.GoblinsTracks;
	}

// Hardened Functions
	function initMap()
	{
		local baseArea = ::MapGen.get("tactical.hills");
		local minX = baseArea.getMinX();
		local minY = baseArea.getMinY();
		::Tactical.resizeScene(minX, minY);

		baseArea.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, null);

		local properties = ::Const.Tactical.CombatInfo.getClone();
		properties.LocationTemplate = clone ::Const.Tactical.LocationTemplate;

		local objectFilling = ::MapGen.get("tactical.goblin_camp");
		objectFilling.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, properties.LocationTemplate);

		::Tactical.getWeather().setAmbientLightingPreset(5);
		::Tactical.getWeather().setAmbientLightingSaturation(0.9);
	}

	function initNPCs()
	{
		local goblinCityLocation = ::new("scripts/entity/world/locations/legendary/unique_goblin_city_location");
		goblinCityLocation.location.onSpawned = function() {};

		local entities = [];
		local mockObject = ::Hardened.mockFunction(::Const.World.Common, "addTroop", function( _party, _troop, _updateStrength = true, _minibossify = 0 ) {
			local entity = clone _troop.Type;
			entity.Faction <- ::Const.Faction.Goblins;
			entity.Variant = 0;
			entities.push(entity);
			return { value = null };
		});
		goblinCityLocation.onSpawned();
		mockObject.cleanup();

		::Tactical.Entities.spawnEntitiesInFormation(entities, 1);
	}
});

