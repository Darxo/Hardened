this.scenario_hd_witch_hut <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Witch Hut";
		this.m.Description = "[p=c][img]gfx/ui/events/event_115.png[/img][/p]\n[p=c]A skewed and withered hut that looks like it could collapse at any moment. Smoke is rising from an awry chimney.[/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.BeastsTracks;
		// ::Tactical.Entities.makeEnemiesKnownToAI();
	}

// Hardened Functions
	function initMap()
	{
		local testMap = ::MapGen.get("tactical.plains");
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
		local entities = [];
		entities.push(clone ::Const.World.Spawn.Troops.Hexe);
		entities.push(clone ::Const.World.Spawn.Troops.Hexe);
		entities.push(clone ::Const.World.Spawn.Troops.Hexe);
		entities.push(clone ::Const.World.Spawn.Troops.Hexe);
		entities.push(clone ::Const.World.Spawn.Troops.DirewolfBodyguard);
		entities.push(clone ::Const.World.Spawn.Troops.DirewolfBodyguard);
		entities.push(clone ::Const.World.Spawn.Troops.SpiderBodyguard);
		entities.push(clone ::Const.World.Spawn.Troops.SpiderBodyguard);
		entities.push(clone ::Const.World.Spawn.Troops.SpiderBodyguard);
		entities.push(clone ::Const.World.Spawn.Troops.DirewolfHIGH);
		entities.push(clone ::Const.World.Spawn.Troops.DirewolfHIGH);
		entities.push(clone ::Const.World.Spawn.Troops.DirewolfHIGH);
		entities.push(clone ::Const.World.Spawn.Troops.DirewolfHIGH);
		entities.push(clone ::Const.World.Spawn.Troops.DirewolfHIGH);
		entities.push(clone ::Const.World.Spawn.Troops.UnholdBog);
		entities.push(clone ::Const.World.Spawn.Troops.Unhold);
		entities.push(clone ::Const.World.Spawn.Troops.Ghoul);
		entities.push(clone ::Const.World.Spawn.Troops.Ghoul);
		entities.push(clone ::Const.World.Spawn.Troops.GhoulHIGH);

		foreach (entity in entities)
		{
			entity.Faction <- ::Const.Faction.Beasts;
			entity.Variant = 0;
		}

		::Tactical.Entities.spawnEntitiesInFormation(entities, 1);
	}
});

