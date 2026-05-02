this.scenario_hd_abandoned_village <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Abandoned Village";
		this.m.Description = "[p=c][img]gfx/ui/events/event_178.png[/img][/p]\n[p=c]A seemingly abandoned village, with a towering statue dominating the square.[/p]";
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

		local properties = ::Const.Tactical.CombatInfo.getClone();
		properties.LocationTemplate = clone ::Const.Tactical.LocationTemplate;

		local objectFilling = ::MapGen.get("tactical.golems_village");
		objectFilling.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, properties.LocationTemplate);
	}

	function HD_placePlayerCharacters()
	{
		::World.Assets.updateFormation();
		::Tactical.Entities.placePlayersInFormation(::World.getPlayerRoster().getAll(), 3);
	}

	function initNPCs()
	{
		local abandonedVillageEvent = ::new("scripts/events/events/location/abandoned_village_enter_event");

		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", ::Const.FactionType.Undead, 7, 8, 7, 8, true);
		for (local i = 1; i <= 2; ++i)
		{
			abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", ::Const.FactionType.Undead, 6, 9, 6, 9, false);
		}
		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", ::Const.FactionType.Undead, 6, 9, 6, 9, false);

		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", ::Const.FactionType.Undead, 7, 8, 25, 26, true);
		for (local i = 1; i <= 2; ++i)
		{
			abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", ::Const.FactionType.Undead, 6, 9, 24, 27, false);
		}
		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", ::Const.FactionType.Undead, 6, 9, 24, 27, false);

		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", ::Const.FactionType.Undead, 24, 25, 15, 16, true);
		for (local i = 1; i <= 2; ++i)
		{
			abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem", ::Const.FactionType.Undead, 23, 26, 14, 17, false);
		}
		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", ::Const.FactionType.Undead, 23, 26, 14, 17, false);
		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", ::Const.FactionType.Undead, 13, 15, 3, 5, false);
		abandonedVillageEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed", ::Const.FactionType.Undead, 13, 15, 26, 28, false);
	}
});

