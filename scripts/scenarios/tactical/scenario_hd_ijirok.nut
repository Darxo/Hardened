this.scenario_hd_ijirok <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Ijirok";
		this.m.Description = "[p=c][img]gfx/ui/events/event_142.png[/img][/p]\n[p=c]Within the barren tundra, you find a prime hunting ground around a small lake, and so you decide to go on a short one-day kill.[/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.BeastsTracks;
		// ::Tactical.Entities.makeEnemiesKnownToAI();
	}

	function initMap()
	{
		local testMap = ::MapGen.get("tactical.tundra");
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
		local entry = clone ::Const.World.Spawn.Troops.TricksterGod;
		entry.Faction <- ::Const.Faction.Beasts;
		::Tactical.Entities.spawnEntitiesInFormation([entry], 1);
	}
});

