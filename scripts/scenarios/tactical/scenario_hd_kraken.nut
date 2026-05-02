this.scenario_hd_kraken <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Kraken";
		this.m.Description = "[p=c][img]gfx/ui/events/event_103.png[/img][/p]\n[p=c]Let the Beast of Beasts have its feast![/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.BeastsTracks;
		// ::Tactical.Entities.makeEnemiesKnownToAI();
	}

	function initMap()
	{
		local testMap = ::MapGen.get("tactical.swamp");
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
		// In a real Kraken Test Fight the Kraken Head spawned 2 tiles further east
		// Not sure if that was variance/randomness or I overlooked something
		local entry = clone ::Const.World.Spawn.Troops.Kraken;
		entry.Faction <- ::Const.Faction.Beasts;
		::Tactical.Entities.spawnEntitiesInFormation([entry], 1);
	}
});

