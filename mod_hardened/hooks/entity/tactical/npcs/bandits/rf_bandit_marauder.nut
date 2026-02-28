// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_marauder", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Thick;	// Reforged: ::Const.Bodies.AllMale

		// Switcheroo the RF_BanditHighwayman ID into that of RF_BanditMarauder, to make Reforged assign the ID, that we want
		// We must do this via switcheroo, so that the name assignment works correctly
		local oldRF_BanditHighwayman = ::Const.EntityType.RF_BanditHighwayman;
		::Const.EntityType.RF_BanditHighwayman = ::Const.EntityType.RF_BanditMarauder;
		__original();
		::Const.EntityType.RF_BanditHighwayman = oldRF_BanditHighwayman;

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 100 - 110
			[12, "scripts/items/armor/patched_mail_shirt"],
			[12, "scripts/items/armor/worn_mail_shirt"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/rf_battle_axe"],
			[12, "scripts/items/weapons/rf_greatsword"],
			[12, "scripts/items/weapons/longaxe"],
			[12, "scripts/items/weapons/polehammer"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() function()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		// This champion only ever spawns with named weapons, never with named gear
		local namedMeleeWeapon = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/named/named_greatsword"],
			[12, "scripts/items/weapons/named/named_greataxe"],
			[12, "scripts/items/weapons/named/named_longaxe"],
			[12, "scripts/items/weapons/named/named_polehammer"],
		]).roll();
		this.getItems().equip(::new(namedMeleeWeapon));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_fresh_and_furious"));

		return true;
	}}.makeMiniboss;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Axe))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_dismantle"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_rattle"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_death_dealer"));
			}
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_bandits");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = ::Math.rand(150, 255);
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_BanditMarauder);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
		this.getSkills().add(::new("scripts/skills/perks/perk_steel_brow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
