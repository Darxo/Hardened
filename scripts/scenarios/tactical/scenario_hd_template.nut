this.scenario_hd_template <- this.inherit("scripts/scenarios/tactical/scenario_template", {
	m = {
		Name = "Scenario Template",
		Description = "Scenario Description",
	},
	function create()
	{
	}

	function generate()
	{
		this.createStash();
		this.initMap();
		this.initPlayerCharacters();
		this.initNPCs();
		this.initStash();
		// ::Tactical.Entities.makeEnemiesKnownToAI();
		::Tactical.CameraDirector.addMoveToTileEvent(0, ::Tactical.getTile(15, 14 - 15 / 2), 1, null, null, 0, 100);
	}

	function initMap()	// Virtual
	{
	}

	function initPlayerCharacters()
	{
		this.HD_createPlayerRoster();
		this.HD_placePlayerCharacters();
	}

	function initNPCs()		// Virtual
	{
	}

	function initStash()
	{
		this.HD_initDefaultStash();
	}

// Vanilla Helper Functions
	function spawnEntity( _script, _minX = 4, _maxX = 28, _minY = 4, _maxY = 28 )
	{
		local x = 0;
		local y = 0;
		local n = 0;

		while (1)
		{
			x = this.Math.rand(_minX, _maxX);
			y = this.Math.rand(_minY, _maxY) - x / 2;

			if (!::Tactical.getTile(x, y).IsEmpty)
			{
				::Tactical.getTile(x, y).removeObject();
			}

			if (::Tactical.getTile(x, y).IsEmpty)
			{
				break;
			}
		}

		return ::Tactical.spawnEntity(_script, x, y);
	}

	function spawnEnemy( _script, _minX = 4, _maxX = 28, _minY = 4, _maxY = 28 )
	{
		local x = 0;
		local y = 0;
		local n = 0;

		while (1)
		{
			x = this.Math.rand(_minX, _maxX);
			y = this.Math.rand(_minY, _maxY);

			if (x >= 8 && x <= 18 && y >= 9 && y <= 18)
			{
				continue;
			}

			y = y - x / 2;

			if (!::Tactical.getTile(x, y).IsEmpty)
			{
				::Tactical.getTile(x, y).removeObject();
			}

			if (::Tactical.getTile(x, y).IsEmpty)
			{
				break;
			}
		}

		return ::Tactical.spawnEntity(_script, x, y);
	}


// New Functions
	function HD_createPlayerRoster()
	{
		function createNewPlayer()
		{
			local player = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
			player.setName(this.getRandomPlayerName());
			player.setScenarioValues();
			return player;
		}

		local items;

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/kettle_hat"));
		items.equip(::new("scripts/items/armor/padded_leather"));
		items.equip(::new("scripts/items/weapons/billhook"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/armor/leather_tunic"));
		items.equip(::new("scripts/items/weapons/billhook"));
		items.equip(::new("scripts/items/helmets/hood"));
		items.addToBag(::new("scripts/items/weapons/dagger"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/armor/thick_tunic"));
		items.equip(::new("scripts/items/weapons/hunting_bow"));
		items.equip(::new("scripts/items/ammo/quiver_of_arrows"));
		items.addToBag(::new("scripts/items/weapons/dagger"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/aketon_cap"));
		items.equip(::new("scripts/items/armor/gambeson"));
		items.equip(::new("scripts/items/weapons/crossbow"));
		items.equip(::new("scripts/items/ammo/quiver_of_bolts"));
		items.addToBag(::new("scripts/items/weapons/dagger"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/armor/leather_lamellar"));
		items.equip(::new("scripts/items/tools/player_banner"));
		items.addToBag(::new("scripts/items/weapons/dagger"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/kettle_hat"));
		items.equip(::new("scripts/items/armor/lamellar_harness"));
		items.equip(::new("scripts/items/weapons/greatsword"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/nasal_helmet"));
		items.equip(::new("scripts/items/armor/patched_mail_shirt"));
		items.equip(::new("scripts/items/weapons/military_cleaver"));
		items.equip(::new("scripts/items/shields/wooden_shield"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/armor/mail_shirt"));
		items.equip(::new("scripts/items/weapons/hand_axe"));
		items.equip(::new("scripts/items/shields/wooden_shield"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/flat_top_helmet"));
		items.equip(::new("scripts/items/armor/mail_shirt"));
		items.equip(::new("scripts/items/weapons/boar_spear"));
		items.equip(::new("scripts/items/shields/wooden_shield"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/nasal_helmet_with_rusty_mail"));
		items.equip(::new("scripts/items/armor/mail_shirt"));
		items.equip(::new("scripts/items/weapons/warhammer"));
		items.equip(::new("scripts/items/shields/wooden_shield"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/hood"));
		items.equip(::new("scripts/items/armor/padded_surcoat"));
		items.equip(::new("scripts/items/weapons/winged_mace"));
		items.equip(::new("scripts/items/shields/wooden_shield"));

		items = createNewPlayer().getItems();
		items.equip(::new("scripts/items/helmets/mail_coif"));
		items.equip(::new("scripts/items/armor/coat_of_plates"));
		items.equip(::new("scripts/items/weapons/two_handed_hammer"));
	}

	function HD_placePlayerCharacters()
	{
		::World.Assets.updateFormation();
		::Tactical.Entities.placePlayersInFormation(::World.getPlayerRoster().getAll());
	}

	function HD_initDefaultStash()
	{
		this.Stash.clear();
		this.Stash.resize(117);
		this.Stash.setLocked(false);
		this.Stash.add(::new("scripts/items/weapons/dagger"));
		this.Stash.add(::new("scripts/items/weapons/scramasax"));
		this.Stash.add(::new("scripts/items/weapons/javelin"));
		this.Stash.add(::new("scripts/items/weapons/javelin"));
		this.Stash.add(::new("scripts/items/weapons/throwing_axe"));
		this.Stash.add(::new("scripts/items/weapons/throwing_axe"));
		this.Stash.add(::new("scripts/items/weapons/hatchet"));
		this.Stash.add(::new("scripts/items/weapons/hatchet"));
		this.Stash.add(::new("scripts/items/weapons/hand_axe"));
		this.Stash.add(::new("scripts/items/weapons/hand_axe"));
		this.Stash.add(::new("scripts/items/weapons/warhammer"));
		this.Stash.add(::new("scripts/items/weapons/warhammer"));
		this.Stash.add(::new("scripts/items/weapons/shortsword"));
		this.Stash.add(::new("scripts/items/weapons/shortsword"));
		this.Stash.add(::new("scripts/items/weapons/falchion"));
		this.Stash.add(::new("scripts/items/weapons/falchion"));
		this.Stash.add(::new("scripts/items/weapons/arming_sword"));
		this.Stash.add(::new("scripts/items/weapons/arming_sword"));
		this.Stash.add(::new("scripts/items/weapons/military_cleaver"));
		this.Stash.add(::new("scripts/items/weapons/military_cleaver"));
		this.Stash.add(::new("scripts/items/weapons/greatsword"));
		this.Stash.add(::new("scripts/items/weapons/greatsword"));
		this.Stash.add(::new("scripts/items/weapons/greatsword"));
		this.Stash.add(::new("scripts/items/weapons/greatsword"));
		this.Stash.add(::new("scripts/items/weapons/greataxe"));
		this.Stash.add(::new("scripts/items/weapons/greataxe"));
		this.Stash.add(::new("scripts/items/weapons/greataxe"));
		this.Stash.add(::new("scripts/items/weapons/billhook"));
		this.Stash.add(::new("scripts/items/weapons/billhook"));
		this.Stash.add(::new("scripts/items/weapons/billhook"));
		this.Stash.add(::new("scripts/items/weapons/militia_spear"));
		this.Stash.add(::new("scripts/items/weapons/militia_spear"));
		this.Stash.add(::new("scripts/items/weapons/boar_spear"));
		this.Stash.add(::new("scripts/items/weapons/boar_spear"));
		this.Stash.add(::new("scripts/items/weapons/boar_spear"));
		this.Stash.add(::new("scripts/items/weapons/bludgeon"));
		this.Stash.add(::new("scripts/items/weapons/bludgeon"));
		this.Stash.add(::new("scripts/items/weapons/winged_mace"));
		this.Stash.add(::new("scripts/items/weapons/winged_mace"));
		this.Stash.add(::new("scripts/items/weapons/winged_mace"));
		this.Stash.add(::new("scripts/items/weapons/winged_mace"));
		this.Stash.add(::new("scripts/items/weapons/flail"));
		this.Stash.add(::new("scripts/items/weapons/flail"));
		this.Stash.add(::new("scripts/items/weapons/flail"));
		this.Stash.add(::new("scripts/items/weapons/short_bow"));
		this.Stash.add(::new("scripts/items/weapons/short_bow"));
		this.Stash.add(::new("scripts/items/weapons/hunting_bow"));
		this.Stash.add(::new("scripts/items/weapons/hunting_bow"));
		this.Stash.add(::new("scripts/items/weapons/crossbow"));
		this.Stash.add(::new("scripts/items/weapons/crossbow"));
		this.Stash.add(::new("scripts/items/weapons/crossbow"));
		this.Stash.add(::new("scripts/items/shields/wooden_shield"));
		this.Stash.add(::new("scripts/items/shields/wooden_shield"));
		this.Stash.add(::new("scripts/items/shields/kite_shield"));
		this.Stash.add(::new("scripts/items/shields/kite_shield"));
		this.Stash.add(::new("scripts/items/shields/kite_shield"));
		this.Stash.add(::new("scripts/items/helmets/hood"));
		this.Stash.add(::new("scripts/items/helmets/aketon_cap"));
		this.Stash.add(::new("scripts/items/helmets/full_aketon_cap"));
		this.Stash.add(::new("scripts/items/helmets/nasal_helmet"));
		this.Stash.add(::new("scripts/items/helmets/padded_nasal_helmet"));
		this.Stash.add(::new("scripts/items/helmets/nasal_helmet_with_mail"));
		this.Stash.add(::new("scripts/items/helmets/mail_coif"));
		this.Stash.add(::new("scripts/items/helmets/closed_mail_coif"));
		this.Stash.add(::new("scripts/items/helmets/reinforced_mail_coif"));
		this.Stash.add(::new("scripts/items/helmets/kettle_hat"));
		this.Stash.add(::new("scripts/items/helmets/padded_kettle_hat"));
		this.Stash.add(::new("scripts/items/helmets/kettle_hat_with_mail"));
		this.Stash.add(::new("scripts/items/helmets/flat_top_helmet"));
		this.Stash.add(::new("scripts/items/helmets/flat_top_with_mail"));
		this.Stash.add(::new("scripts/items/helmets/full_helm"));
		this.Stash.add(::new("scripts/items/helmets/full_helm"));
		this.Stash.add(::new("scripts/items/armor/padded_surcoat"));
		this.Stash.add(::new("scripts/items/armor/gambeson"));
		this.Stash.add(::new("scripts/items/armor/gambeson"));
		this.Stash.add(::new("scripts/items/armor/padded_leather"));
		this.Stash.add(::new("scripts/items/armor/padded_leather"));
		this.Stash.add(::new("scripts/items/armor/mail_shirt"));
		this.Stash.add(::new("scripts/items/armor/mail_shirt"));
		this.Stash.add(::new("scripts/items/armor/mail_shirt"));
		this.Stash.add(::new("scripts/items/armor/lamellar_harness"));
		this.Stash.add(::new("scripts/items/armor/coat_of_plates"));
		this.Stash.add(::new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(::new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(::new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(::new("scripts/items/ammo/quiver_of_arrows"));
		this.Stash.add(::new("scripts/items/ammo/quiver_of_bolts"));
		this.Stash.add(::new("scripts/items/ammo/quiver_of_bolts"));
		this.Stash.add(::new("scripts/items/ammo/quiver_of_bolts"));
		this.Stash.add(::new("scripts/items/accessory/wardog_item"));
		this.Stash.add(::new("scripts/items/accessory/wardog_item"));
		this.Stash.add(::new("scripts/items/accessory/wardog_item"));
		this.Stash.add(::new("scripts/items/accessory/wardog_item"));
		this.Stash.add(::new("scripts/items/accessory/wardog_item"));
		this.Stash.add(::new("scripts/items/accessory/wardog_item"));
	}

});

