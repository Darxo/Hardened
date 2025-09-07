// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_scoundrel", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Skinny;	// Reforged ::Const.Bodies.AllMale
		__original();

		this.m.ChanceForNoChest = 50;
		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/tattered_sackcloth"],
			[12, "scripts/items/armor/leather_tunic"],
		]);
		this.m.ChanceForNoHelmet = 50;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/basic_mail_shirt"],
			[12, "scripts/items/armor/mail_shirt"],
		]);
		this.m.ChanceForNoWeapon = 50;
		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/hatchet"],
			[12, "scripts/items/weapons/militia_spear"],
		]);
		this.m.ChanceForOffhand = 50;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/wooden_shield"],
			[12, "scripts/items/shields/kite_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	// Overwrite, because we completely replace Reforged/Vanilla gear assignments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		// this.HD_assignArmor();
		// this.HD_assignOtherGear();
	}}.assignRandomEquipment;

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_bandits");
		if (::Math.rand(1, 100) <= 10)
		{
			local pox = this.getSprite("tattoo_head");
			pox.Visible = true;
			pox.setBrush("bust_head_pox_01");
		}
		else if (::Math.rand(1, 100) <= 15)
		{
			local pox = this.getSprite("tattoo_head");
			pox.Visible = true;
			pox.setBrush("bust_head_darkeyes_01");
		}
		else
		{
			local dirt = this.getSprite("dirt");
			dirt.Visible = true;
		}

		if (::Math.rand(1, 100) <= 25)
		{
			this.getSprite("eye_rings").Visible = true;
		}

		this.getSprite("armor").Saturation = 0.8;
		this.getSprite("helmet").Saturation = 0.8;
		this.getSprite("helmet_damage").Saturation = 0.8;
		this.getSprite("shield_icon").Saturation = 0.8;
		this.getSprite("shield_icon").setBrightness(0.9);
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_BanditScoundrel);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor = ::Reforged.ItemTable.BanditArmorBalanced.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax > 65) return 0.0;
					return _weight;
				},
				Add = [
					[1, "scripts/items/armor/monk_robe"]
				]
			})
			this.m.Items.equip(::new(armor));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head) && ::Math.rand(1, 100) > 50)
		{
			local helmet = ::Reforged.ItemTable.BanditHelmetBalanced.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax > 40) return 0.0;
					return _weight;
				}
			})
			if (helmet != null) this.m.Items.equip(::new(helmet));
		}
	}

	// Assign Head and Body armor to this character
	q.HD_assignOtherGear <- function()
	{
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Mainhand))
		{
			local weapon = ::MSU.Class.WeightedContainer([
				[1, "scripts/items/weapons/bludgeon"],
				[1, "scripts/items/weapons/butchers_cleaver"],
				[1, "scripts/items/weapons/dagger"],
				[1, "scripts/items/weapons/hatchet"],
				[1, "scripts/items/weapons/militia_spear"],
				[1, "scripts/items/weapons/pickaxe"],
				[1, "scripts/items/weapons/reinforced_wooden_flail"],
				[1, "scripts/items/weapons/shortsword"],
				[1, "scripts/items/weapons/wooden_flail"],
				[1, "scripts/items/weapons/wooden_stick"],

				[1, "scripts/items/weapons/pitchfork"],
				[1, "scripts/items/weapons/woodcutters_axe"]
			]).roll();

			this.m.Items.equip(::new(weapon));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Offhand))
		{
			local shield = ::MSU.Class.WeightedContainer([
				[1, "scripts/items/shields/buckler_shield"],
				[1, "scripts/items/shields/wooden_shield"]
			]).rollChance(33);

			if (shield != null) this.m.Items.equip(::new(shield));
		}
	}
});



