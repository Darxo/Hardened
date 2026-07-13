this.scenario_hd_sunken_library <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Sunken Library";
		this.m.Description = "[p=c][img]gfx/ui/events/event_173.png[/img][/p]\n[p=c]You\'ve stumbled across a great gilded dome protruding ever so slightly from the sands.[/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.UndeadTracks;
		// ::Tactical.Entities.makeEnemiesKnownToAI();
	}

	function initMap()
	{
		local sinkhole = ::MapGen.get("tactical.sinkhole");
		local minX = sinkhole.getMinX();
		local minY = sinkhole.getMinY();
		::Tactical.resizeScene(minX, minY);

		sinkhole.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, null);

		local properties = ::Const.Tactical.CombatInfo.getClone();
		properties.LocationTemplate = clone ::Const.Tactical.LocationTemplate;
		// ShiftX must be 0 so that the sunken_library template objects are centered correctly
		// the Vanilla sunken_library template never sets this to 0, which is confusing, as to why it works for them
		properties.LocationTemplate.ShiftX = 0;

		local sunken_library = ::MapGen.get("tactical.sunken_library");
		sunken_library.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, properties.LocationTemplate);
	}

	function HD_placePlayerCharacters()
	{
		::World.Assets.updateFormation();
		::Tactical.Entities.placePlayersInFormation(::World.getPlayerRoster().getAll(), -10);
	}

	function initNPCs()
	{
		{	// Phylacteries
			local phylacteries = 10;
			local phylactery_tiles = [];
			while (phylacteries > 0)
			{
				local x = ::Math.rand(10, 28);
				local y = ::Math.rand(4, 28);
				local tile = ::Tactical.getTileSquare(x, y);
				if (!tile.IsEmpty) continue;

				local skip = false;
				foreach (t in phylactery_tiles)
				{
					if (t.getDistanceTo(tile) <= 5)
					{
						skip = true;
						break;
					}
				}
				if (skip) continue;

				--phylacteries;
				local e = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/phylactery", tile.Coords);
				e.setFaction(::Const.Faction.Undead);
				phylactery_tiles.push(tile);
			}

			local toRise = 5;
			while (toRise > 0 && phylactery_tiles.len() > 0)
			{
				local phylactery = ::MSU.Array.rand(phylactery_tiles);
				if (phylactery.SquareCoords.X > 14)
				{
					phylactery.Level = 3;
					--toRise;
				}
				::MSU.Array.removeByValue(phylactery_tiles, phylactery);
			}
		}

		{	// Lich

			local lich = 1;

			while (lich > 0)
			{
				local x = this.Math.rand(9, 10);
				local y = this.Math.rand(15, 17);
				local tile = ::Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty) continue;

				local e = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_lich", tile.Coords);
				e.setFaction(::Const.Faction.Undead);
				e.assignRandomEquipment();
				--lich;
			}
		}

		// Todo: remove treasure hunters and make the player be the treasure hunters instead
		{	// Treasure Hunter
			local treasureHunters = 3;
			while (treasureHunters > 0)
			{
				local x = this.Math.rand(9, 11);
				local y = this.Math.rand(11, 21);
				local tile = ::Tactical.getTileSquare(x, y);
				if (!tile.IsEmpty) continue;

				local e = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie_treasure_hunter", tile.Coords);
				e.setFaction(::Const.Faction.Undead);
				e.assignRandomEquipment();
				local item = e.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
				item.setCondition(this.Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
				--treasureHunters;
			}
		}

		{	// Ancient Honor Guards
			local heavy = 4;
			while (heavy > 0)
			{
				local x = this.Math.rand(9, 14);
				local y = this.Math.rand(8, 20);
				local tile = ::Tactical.getTileSquare(x, y);
				if (!tile.IsEmpty) continue;

				local e = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy", tile.Coords);
				e.setFaction(::Const.Faction.Undead);
				e.assignRandomEquipment();
				local item = e.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
				item.setCondition(::Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
				--heavy;
			}
		}

		{	// Ancient Honor Guard Polearms
			local heavy_polearm = 4;
			while (heavy_polearm > 0)
			{
				local x = this.Math.rand(12, 14);
				local y = this.Math.rand(12, 26);
				local tile = ::Tactical.getTileSquare(x, y);
				if (!tile.IsEmpty) continue;

				local e = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/skeleton_heavy_polearm", tile.Coords);
				e.setFaction(::Const.Faction.Undead);
				e.assignRandomEquipment();
				local item = e.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
				item.setCondition(::Math.rand(item.getConditionMax() / 2, item.getConditionMax()));
				--heavy_polearm;
			}
		}

		{	// Ancient Honorguard Bodyguards
			local entities = [];
			for (local i = 0; i < 4; ++i)
			{
				local entry = clone ::Const.World.Spawn.Troops.SkeletonHeavyBodyguard;
				entry.Faction <- ::Const.Faction.Undead;
				entities.push(entry);
			}

			::Tactical.Entities.spawnEntitiesAtCenter(entities);
		}
	}
});
