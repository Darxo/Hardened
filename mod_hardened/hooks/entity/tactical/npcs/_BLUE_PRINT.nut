// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design
/*
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/BLUE_PRINT", function(q) {
	q.create = @(__original) function()
	{
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
		this.m.ChanceForNoOffhand = 50;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/wooden_shield"],
			[12, "scripts/items/shields/kite_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() function()
	{
		// Todo: remove one of these
		this.actor.onInit();
		this.human.onInit();

		this.HD_initSprites();
		this.HD_onInitStatsAndSkills();
	}

	// Assign Special [named] Equipment and Perks for when this enemy appears as a champion
	q.makeMiniboss = @() function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		// Assign Special Gear
		local gearPiece = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/tattered_sackcloth"],
			[12, "scripts/items/armor/leather_tunic"],
		]).roll();
		this.getItems().equip(::new(gearPiece));

		// Base Stat Adjustments
		this.m.ActionPoints = 9;
		this.m.BaseProperties.ActionPoints = 9;
		this.m.Skills.update();
	}

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
		this.HD_assignOtherGear();
	}}.assignRandomEquipment;

	q.assignRandomEquipment = @(__original) { function assignRandomEquipment()
	{
		__original();

		// We remove any weapon/offhand assigned by Reforged, as we assign them outselves later
		::Hardened.util.removeAllButArmor(this);

		this.HD_assignOtherGear();
	}}.assignRandomEquipment;

// Reforged Functions
	// Assign Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		// Assign Perks depending on mainhand weapon
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Axe))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_axe"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Bow))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_bow"));
			}
		}
	}

// New Functions
	q.HD_initSprites <- function()
	{
		// Copy&Paste all vanilla setup code in here
		this.getSprite("socket").setBrush("bust_base_bandits");
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);
	}

	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.BLUE_PRINT);
		b.TargetAttractionMult = 0.1;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/captain_effect"));
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));
		this.getSkills().add(::new("scripts/skills/perks/perk_brawny"));
		this.getSkills().add(::new("scripts/skills/perks/perk_quick_hands"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/rotation"));
		this.getSkills().add(::new("scripts/skills/actives/recover_skill"));
		this.getSkills().add(::new("scripts/skills/actives/wake_ally_skill"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{

	}
});
*/
