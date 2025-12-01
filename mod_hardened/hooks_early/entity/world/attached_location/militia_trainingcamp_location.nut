::Hardened.HooksMod.hook("scripts/entity/world/attached_location/militia_trainingcamp_location", function(q) {
	// Feat: Display the original location name for ruined
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttackable = true;
		this.m.IsScalingDefenders = true;

		// Tactical Map
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.Fortification = ::Const.Tactical.FortificationType.Palisade;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 1;

		// Defender
		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Militia;
		this.setDefenderSpawnList(::Const.World.Spawn.Militia);

		// Loot
		this.m.NamedWeaponsList = ::Const.Items.NamedWeapons;
		this.m.NamedArmorsList = ::Const.Items.NamedArmors;
		this.m.NamedHelmetsList = ::Const.Items.NamedHelmets;
		this.m.NamedShieldsList = ::Const.Items.NamedShields;

	// Hardened Member
		this.m.IsRaidable = true;
	}

	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);
		this.dropAmmo(::Math.rand(this.m.Resources / 36, this.m.Resources / 8), _lootTable);
		this.dropArmorParts(::Math.rand(this.m.Resources / 64, this.m.Resources / 16), _lootTable);
		this.dropMedicine(::Math.rand(this.m.Resources / 128, this.m.Resources / 32), _lootTable);

		this.HD_dropFood(::Math.rand(1, 2), [
			"bread_item",
			"beer_item",
			"dried_fruits_item",
			"ground_grains_item",
			"roots_and_berries_item",
			"pickled_mushrooms_item",
			"smoked_ham_item",
			"mead_item",
			"cured_venison_item",
			"goat_cheese_item",
		], _lootTable, 0.8, 0.8);
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		if (this.m.Resources == 0) this.m.Resources = 200;
	}
});
