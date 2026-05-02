this.scenario_hd_artifact_reliquary <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Artifact Reliquary";
		this.m.Description = "[p=c][img]gfx/ui/events/event_182.png[/img][/p]\n[p=c]The estate towers over the area with pure cut stoneworks and colored roofing tiles. It has something most royalty cannot afford, which is a sense of taste.[/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.UndeadTracks;
	}

// Hardened Functions
	function initMap()
	{
		local baseArea = ::MapGen.get("tactical.golems");
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

		local objectFilling = ::MapGen.get("tactical.golems_lair");
		objectFilling.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY,
		}, properties.LocationTemplate);

		::Tactical.getWeather().setAmbientLightingPreset(5);
		::Tactical.getWeather().setAmbientLightingSaturation(0.9);
	}

	function HD_placePlayerCharacters()
	{
		::World.Assets.updateFormation();
		::Tactical.Entities.placePlayersInFormation(::World.getPlayerRoster().getAll(), -4, -3);
	}

	function initNPCs()
	{
		local artifactReliquaryEvent = ::new("scripts/events/events/location/artifact_reliquary_enter_event");

		local sorcerers = [];
		local greaterGolems = [];
		local entity;
		entity = artifactReliquaryEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/grand_diviner", ::Const.FactionType.Undead, 16, 18, 10, 14, 0, true, sorcerers);
		if (entity != null) sorcerers.push(entity);

		for (local i = 1; i <= 4; ++i)
		{
			entity = artifactReliquaryEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/fault_finder", ::Const.FactionType.Undead, 18, 21, 6, 24, 0, true, sorcerers);
			if (entity != null) sorcerers.push(entity);
		}

		for (local i = 1; i <= 4; ++i)
		{
			artifactReliquaryEvent.spawnGuardEntity("scripts/entity/tactical/enemies/lesser_flesh_golem_unarmed_bodyguard", ::Const.FactionType.Undead, sorcerers);
		}

		for (local i = 1; i <= 3; ++i)
		{
			entity = artifactReliquaryEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/greater_flesh_golem", ::Const.FactionType.Undead, 15, 17, 6, 24, i, true, greaterGolems);
			if (entity != null) greaterGolems.push(entity);
		}

		{	// Flesh Cradles
			local playersAndFleshCradles = [];
			local brothers = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);
			foreach (bro in brothers)
			{
				playersAndFleshCradles.push(bro);
			}

			for (local i = 1; i <= 10; ++i)
			{
				entity = artifactReliquaryEvent.spawnEntityWithinBounds("scripts/entity/tactical/enemies/flesh_cradle", ::Const.FactionType.Undead, 4, 24, 4, 24, 0, true, playersAndFleshCradles);
				if (entity != null) playersAndFleshCradles.push(entity);
			}
		}
	}
});

