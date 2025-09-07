::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_killer", function(q) {
	// Public
// One Handed
	q.m.AvailableOneHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/boar_spear",
		"scripts/items/weapons/rondel_dagger",
		"scripts/items/weapons/arming_sword",
	]);
	q.m.AvailableNamedOneHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/named/named_spear",
		"scripts/items/weapons/named/named_dagger",
		"scripts/items/weapons/named/named_sword",
	]);

// Two Handed
	q.m.AvailableTwoHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/billhook",
		"scripts/items/weapons/rf_poleflail",
	]);
	q.m.AvailableNamedTwoHandedWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/named/named_billhook",
		"scripts/items/weapons/named/named_rf_poleflail",
	]);

// Throwing Weapons
	q.m.AvailableThrowingWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/javelin",
		"scripts/items/weapons/throwing_axe",
	]);
	q.m.AvailableNamedThrowingWeapons <- ::MSU.Class.WeightedContainer().addMany(1, [
		"scripts/items/weapons/named/named_javelin",
		"scripts/items/weapons/named/named_throwing_axe",
	]);

	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		if (!this.m.IsMiniboss)
		{
			if (::Math.rand(1, 2) == 1)
			{
				::Hardened.util.replaceMainhand(this, this.m.AvailableOneHandedWeapons.roll());
				if (this.getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
				{
					this.getItems().equip(::new("scripts/items/tools/throwing_net"));	// A one-handed killer now always has a net
				}
			}
			else
			{
				::Hardened.util.replaceMainhand(this, this.m.AvailableTwoHandedWeapons.roll());
				if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag))
				{
					this.getItems().addToBag(::new(this.m.AvailableThrowingWeapons.roll()));	// A two-handed killer now always has throwing weapons
				}
			}
		}
	}

	q.makeMiniboss = @(__original) function()
	{
		__original();

		this.getSprite("miniboss").setBrush("bust_miniboss");

		local r = ::Math.rand(1, 100);
		if (r <= 40)	// 40% Chance for a named weapon
		{
			if (::Math.rand(1, 2) == 1)		// Named 1H Weapon
			{
				this.getItems().equip(::new(this.m.AvailableNamedOneHandedWeapons.roll()));
				if (this.getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
				{
					this.getItems().equip(::new("scripts/items/tools/reinforced_throwing_net"));	// A Miniboss always comes with a reinforced net
				}
			}
			else
			{
				if (::Math.rand(1, 2) == 1)	// Two Handed rolled named
				{
					this.getItems().equip(::new(this.m.AvailableNamedTwoHandedWeapons.roll()));
					if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag))
					{
						this.getItems().addToBag(::new(this.m.AvailableThrowingWeapons.roll()));
					}
				}
				else	// Throwing Weapon rolled named
				{
					this.getItems().equip(::new(this.m.AvailableTwoHandedWeapons.roll()));
					if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag))
					{
						this.getItems().addToBag(::new(this.m.AvailableNamedThrowingWeapons.roll()));	// Named Throwing Weapon
					}
				}
			}
		}
		else if (r <= 70)	// 30% Chance for a named armor
		{
			local armor = ::Reforged.ItemTable.NamedArmorNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax <= 100 || conditionMax > 140) return 0.0;
					return _weight;
				}
			})
			if (armor != null) this.getItems().equip(::new(armor));
		}
		else	// 30% Chance for a named helmet
		{
			local helmet = ::Reforged.ItemTable.NamedHelmetNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax <= 90 || conditionMax > 130) return 0.0;
					return _weight;
				}
			})
			if (helmet != null) this.getItems().equip(::new(helmet));
		}

		return true;
	}
});
