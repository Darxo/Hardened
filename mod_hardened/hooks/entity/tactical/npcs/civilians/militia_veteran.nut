// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/militia_veteran", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[24, "scripts/items/weapons/boar_spear"],
			[24, "scripts/items/weapons/goedendag"],
			[16, "scripts/items/weapons/falchion"],
			[16, "scripts/items/weapons/hand_axe"],
			[12, "scripts/items/weapons/hooked_blade"],
			[12, "scripts/items/weapons/pike"],
			[12, "scripts/items/weapons/warfork"],
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
		// This is currently mostly a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		local r = this.Math.rand(1, 6);
		if (r == 1)
		{
			this.getItems().equip(::new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			this.getItems().equip(::new("scripts/items/armor/gambeson"));
		}
		else if (r == 3)
		{
			this.getItems().equip(::new("scripts/items/armor/padded_leather"));
		}
		else if (r == 4)
		{
			this.getItems().equip(::new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 5)
		{
			this.getItems().equip(::new("scripts/items/armor/leather_lamellar"));
		}
		else if (r == 6)
		{
			this.getItems().equip(::new("scripts/items/armor/thick_tunic"));
		}

		local r = this.Math.rand(1, 3);
		if (r == 1)
		{
			this.getItems().equip(::new("scripts/items/helmets/hood"));
		}
		else if (r == 2)
		{
			this.getItems().equip(::new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			this.getItems().equip(::new("scripts/items/helmets/full_aketon_cap"));
		}
	}
});
