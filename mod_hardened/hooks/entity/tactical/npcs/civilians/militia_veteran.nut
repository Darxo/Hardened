// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/militia_veteran", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([	// 60 - 90
			[12, "scripts/items/armor/padded_surcoat"],
			[12, "scripts/items/armor/gambeson"],
			[12, "scripts/items/armor/padded_leather"],
			[12, "scripts/items/armor/leather_lamellar"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 60 - 80
			[12, "scripts/items/helmets/full_aketon_cap"],
			[12, "scripts/items/helmets/full_leather_cap"],
			[12, "scripts/items/helmets/rusty_mail_coif"],
			[12, "scripts/items/helmets/mail_coif"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[18, "scripts/items/weapons/boar_spear"],
			[18, "scripts/items/weapons/goedendag"],
			[12, "scripts/items/weapons/falchion"],
			[12, "scripts/items/weapons/hand_axe"],
			[6, "scripts/items/weapons/hooked_blade"],
			[6, "scripts/items/weapons/pike"],
			[6, "scripts/items/weapons/warfork"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/wooden_shield"],
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
		this.getSprite("accessory_special").setBrush("bust_militia_band_01");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.MilitiaVeteran);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_battle_fervor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
