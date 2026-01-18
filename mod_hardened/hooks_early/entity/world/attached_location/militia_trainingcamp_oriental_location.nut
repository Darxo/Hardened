::Hardened.HooksMod.hook("scripts/entity/world/attached_location/militia_trainingcamp_oriental_location", function(q) {
	// Feat: Display the original location name for ruined
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttackable = true;
		this.m.IsScalingDefenders = true;
		this.m.IsShowingBanner = true;

		// Tactical Map
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.Fortification = ::Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 1;

		// Defender
		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.CityState;
		this.setDefenderSpawnList(::Const.World.Spawn.Southern);

		// Loot
		this.m.NamedWeaponsList = ::Const.Items.NamedSouthernWeapons;
		this.m.NamedArmorsList = ::Const.Items.NamedSouthernArmors;
		this.m.NamedHelmetsList = ::Const.Items.NamedSouthernHelmets;
		this.m.NamedShieldsList = ::Const.Items.NamedSouthernShields;

	// Hardened Member
		this.m.IsRaidable = true;
	}

	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);
		this.dropAmmo(::Math.rand(this.m.Resources / 20, this.m.Resources / 5), _lootTable);
		this.dropArmorParts(::Math.rand(this.m.Resources / 40, this.m.Resources / 10), _lootTable);
		this.dropMedicine(::Math.rand(this.m.Resources / 80, this.m.Resources / 20), _lootTable);
		this.dropMoney(::Math.rand(this.m.Resources / 4, this.m.Resources), _lootTable);

		this.HD_dropFood(::Math.rand(3, 5), [
			"rice_item",
			"rice_item",
			"dates_item",
			"dates_item",
			"bread_item",
			"dried_fruits_item",
			"dried_fish_item",
			"goat_cheese_item",
			"dried_lamb_item",
		], _lootTable, 0.8, 0.8);

		local paintList = [
			"misc/paint_set_item",
			"misc/paint_set_item",
			"misc/paint_set_item",
			"misc/paint_black_item",
			"misc/paint_red_item",
			"misc/paint_orange_red_item",
			"misc/paint_white_blue_item",
			"misc/paint_white_green_yellow_item",
		];
		this.dropTreasure(2, paintList, _lootTable);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (this.m.Resources == 0) this.m.Resources = 280;
	}
});
