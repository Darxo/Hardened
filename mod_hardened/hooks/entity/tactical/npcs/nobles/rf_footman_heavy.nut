// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_footman_heavy", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/arming_sword"],
			[12, "scripts/items/weapons/military_pick"],
			[12, "scripts/items/weapons/flail"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/faction_heater_shield"],
			[12, "scripts/items/shields/faction_kite_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
		this.HD_assignOtherGear();
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_military");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_FootmanHeavy);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_one_with_the_shield"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));
		this.getSkills().add(::new("scripts/skills/perks/perk_shield_expert"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
			local script = ::MSU.Class.WeightedContainer([
				[1, "scripts/items/armor/mail_hauberk"],
				[1, "scripts/items/armor/footman_armor"],
				[1, "scripts/items/armor/reinforced_mail_hauberk"]
			]).roll();
			local armor = ::new(script);
			if (script == "scripts/items/armor/mail_hauberk") armor.setVariant(28);
			this.m.Items.equip(armor);
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head))
		{
			local banner = ::Tactical.State.isScenarioMode() ? this.getFaction() : ::World.FactionManager.getFaction(this.getFaction()).getBanner();
			local helmet;
			if (banner <= 4)
			{
				helmet = ::new(::MSU.Class.WeightedContainer([
					[12, "scripts/items/helmets/kettle_hat_with_mail"],
					[6, "scripts/items/helmets/rf_skull_cap_with_mail"],
					[6, "scripts/items/helmets/rf_sallet_helmet_with_mail"],
				]).roll());
			}
			else if (banner <= 7)
			{
				helmet = ::new(::MSU.Class.WeightedContainer([
					[12, "scripts/items/helmets/flat_top_with_mail"],
					[6, "scripts/items/helmets/rf_skull_cap_with_mail"],
					[6, "scripts/items/helmets/rf_sallet_helmet_with_mail"],
				]).roll());
			}
			else
			{
				helmet = ::new(::MSU.Class.WeightedContainer([
					[12, "scripts/items/helmets/nasal_helmet_with_closed_mail"],
					[6, "scripts/items/helmets/rf_skull_cap_with_mail"],
					[6, "scripts/items/helmets/rf_sallet_helmet_with_mail"],
				]).roll());
			}

			helmet.setPlainVariant();
			this.m.Items.equip(helmet);
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local banner = ::Tactical.State.isScenarioMode() ? this.getFaction() : ::World.FactionManager.getFaction(this.getFaction()).getBanner();
		this.m.Surcoat = banner;
		if (::Math.rand(1, 100) <= this.m.SurcoatChance)
		{
			this.getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));
		}

		this.getOffhandItem().setFaction(banner);	// Color the offhand shield in company colors
	}
});


