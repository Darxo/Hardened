this.scenario_hd_watermill <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Watermill";
		this.m.Description = "[p=c][img]gfx/ui/events/event_109.png[/img][/p]\n[p=c]A small watermill with a stony house at its side. It looks like someone might be living here.[/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.UndeadTracks;
	}

// Hardened Functions
	function initMap()
	{
		local baseArea = ::MapGen.get("tactical.plains");
		local minX = baseArea.getMinX();
		local minY = baseArea.getMinY();
		::Tactical.resizeScene(minX, minY);

		baseArea.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, null);
	}

	function initNPCs()
	{
		local watermillLocation = ::new("scripts/entity/world/locations/legendary/waterwheel_location");
		watermillLocation.location.onSpawned = function() {};

		local entities = [];
		local mockObject = ::Hardened.mockFunction(::Const.World.Common, "addTroop", function( _party, _troop, _updateStrength = true, _minibossify = 0 ) {
			local entity = clone _troop.Type;
			entity.Faction <- ::Const.Faction.Zombies;
			entity.Variant = 0;
			entities.push(entity);
			return { value = null };
		});
		watermillLocation.onSpawned();
		mockObject.cleanup();

		::Tactical.Entities.spawnEntitiesInFormation(entities, 1);
	}
});

