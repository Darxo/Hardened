this.scenario_hd_follow_the_tracks <- this.inherit("scripts/scenarios/tactical/scenario_hd_template", {
	m = {},

	function create()
	{
		this.m.Name = "Follow the Tracks";
		this.m.Description = "[p=c][img]gfx/ui/events/event_75.png[/img][/p]\n[p=c][color=#bcad8c]\"Do you understand, mercenary? I want you to get my property back. I want it placed right where it belongs. And... I want those thieves dead in the mud.\"[/color][/p]";
	}

	function generate()
	{
		this.scenario_hd_template.generate();
		this.m.Music = ::Const.Music.BanditTracks;
	}

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
		local enemies = [];
		for (local i = 1; i <= 6; ++i)
		{
			local entry = clone ::Const.World.Spawn.Troops.BanditThug;
			entry.Faction <- ::Const.Faction.Bandits;
			enemies.push(entry);
		}
		::Tactical.Entities.spawnEntitiesInFormation(enemies, 1);
	}

	function HD_createPlayerRoster()
	{
		for (local i = 1; i <= 3; ++i) this.HD_createPlayer(1);
		for (local i = 1; i <= 5; ++i) this.HD_createPlayer(2);
	}

	function HD_initDefaultStash()
	{
		::Stash.clear();
		::Stash.resize(117);
		::Stash.setLocked(false);

		{	// Weapons
			::Stash.add(::new("scripts/items/weapons/knife"));
			::Stash.add(::new("scripts/items/weapons/knife"));
			::Stash.add(::new("scripts/items/weapons/wooden_stick"));
			::Stash.add(::new("scripts/items/weapons/wooden_stick"));
			::Stash.add(::new("scripts/items/weapons/wonky_bow"));
			::Stash.add(::new("scripts/items/ammo/quiver_of_arrows"));
			::Stash.add(::new("scripts/items/weapons/staff_sling"));
			::Stash.add(::new("scripts/items/weapons/hatchet"));
			::Stash.add(::new("scripts/items/weapons/militia_spear"));
			::Stash.add(::new("scripts/items/weapons/bludgeon"));
			::Stash.add(::new("scripts/items/weapons/shortsword"));
			::Stash.add(::new("scripts/items/weapons/pitchfork"));

			::Stash.add(::new("scripts/items/shields/buckler_shield"));
			::Stash.add(::new("scripts/items/shields/wooden_shield_old"));
			::Stash.add(::new("scripts/items/shields/wooden_shield"));
		}

		{	// Armor & Helmets

			::Stash.add(::new("scripts/items/armor/leather_wraps"));
			::Stash.add(::new("scripts/items/armor/leather_wraps"));
			::Stash.add(::new("scripts/items/armor/leather_wraps"));
			::Stash.add(::new("scripts/items/armor/leather_wraps"));
			::Stash.add(::new("scripts/items/armor/thick_tunic"));
			::Stash.add(::new("scripts/items/armor/thick_tunic"));
			::Stash.add(::new("scripts/items/armor/butcher_apron"));
			::Stash.add(::new("scripts/items/armor/gambeson"));
			::Stash.add(::new("scripts/items/armor/padded_leather"));

			::Stash.add(::new("scripts/items/helmets/hood"));
			::Stash.add(::new("scripts/items/helmets/headscarf"));
			::Stash.add(::new("scripts/items/helmets/straw_hat"));
			::Stash.add(::new("scripts/items/helmets/aketon_cap"));
			::Stash.add(::new("scripts/items/helmets/full_aketon_cap"));
		}

		{	// Utility
			::Stash.add(::new("scripts/items/tools/throwing_net"));
			::Stash.add(::new("scripts/items/accessory/bandage_item"));
			::Stash.add(::new("scripts/items/accessory/bandage_item"));
		}
	}

// New Functions
	function HD_createPlayer( _variant = 1 )
	{
		local player = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
		player.setName(this.getRandomPlayerName());

		local b = player.getBaseProperties();
		b.ActionPoints = 9;
		b.Stamina = 120;
		b.RangedSkill = 40;
		b.MeleeDefense = 5;
		b.RangedDefense = 5;
		b.Initiative = 110;
		if (_variant == 1)
		{
			b.Hitpoints = 60;
			b.Bravery = 50;
			b.MeleeSkill = 55;
		}
		else
		{
			b.Hitpoints = 50;
			b.Bravery = 40;
			b.MeleeSkill = 45;
		}

		local background = ::new("scripts/skills/backgrounds/" + ::MSU.Array.rand(::Const.CharacterBackgrounds));
		background.setScenarioOnly(true);
		player.getSkills().add(background);
		background.buildDescription();
		background.setAppearance();
		local c = player.getCurrentProperties();
		player.m.ActionPoints = c.ActionPoints;
		player.m.Hitpoints = c.Hitpoints;
		player.m.Talents.resize(::Const.Attributes.COUNT, 0);
		player.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);

		return player;
	}
});

