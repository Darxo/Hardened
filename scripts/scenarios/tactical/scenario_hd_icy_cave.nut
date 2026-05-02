this.scenario_hd_icy_cave <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Icy Cave";
		this.m.Description = "[p=c][img]gfx/ui/events/event_144.png[/img][/p]\n[p=c]You discover a cave in the ice with its maw shielded by a gate of thick icicles.[/p]";
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
		local testMap = ::MapGen.get("tactical.snow");
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
		local entry = {
			ID = ::Const.EntityType.BarbarianMadman,
			Variant = 0,
			Row = 0,
			Script = "scripts/entity/tactical/humans/barbarian_madman",
			Faction = ::Const.Faction.Undead,
		};

		::Tactical.Entities.spawnEntitiesInFormation([entry], 1);
	}

	function HD_createPlayerRoster()
	{
		function createNewPlayer()
		{
			local player = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
			player.setName(this.getRandomPlayerName());
			player.setScenarioValues();
			return player;
		}

		local items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/kettle_hat"));
		items.equip(::new("scripts/items/armor/lamellar_harness"));
		items.equip(::new("scripts/items/weapons/greatsword"));
	}
});

