// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/noble_sword"],
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
		this.getSprite("socket").setBrush("bust_base_militia");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Swordmaster);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_parry"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_calculated_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_flow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_sword"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tempo"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_finesse"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_swordmaster_blade_dancer"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor= ::MSU.Class.WeightedContainer([
				[1, "scripts/items/armor/noble_mail_armor"],
				[1, "scripts/items/armor/rf_brigandine_shirt"],
			]).roll();
			this.getItems().equip(::new(armor));
		}

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			local helmet = ::MSU.Class.WeightedContainer([
				[1, "scripts/items/helmets/greatsword_hat"],
				[1, "scripts/items/helmets/reinforced_mail_coif"],
				[1, "scripts/items/helmets/nasal_helmet"],
			]).roll();
			this.getItems().equip(::new(helmet));
		}
	}
});
