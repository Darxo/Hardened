// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_raider", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Skinny;	// Reforged ::Const.Bodies.AllMale
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 130 - 150
			[12, "scripts/items/armor/basic_mail_shirt"],
			[12, "scripts/items/armor/leather_scale_armor"],
			[12, "scripts/items/armor/mail_shirt"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 110 - 130
			[12, "scripts/items/helmets/rf_padded_scale_helmet"],
			[12, "scripts/items/helmets/dented_nasal_helmet"],
			[12, "scripts/items/helmets/padded_nasal_helmet"],
			[12, "scripts/items/helmets/nasal_helmet_with_rusty_mail"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/falchion"],
			[12, "scripts/items/weapons/hand_axe"],
			[12, "scripts/items/weapons/boar_spear"],
		]);

		this.m.ChanceForNoOffhand = 25;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[24, "scripts/items/shields/wooden_shield"],
			[12, "scripts/items/shields/worn_kite_shield"],
			[12, "scripts/items/shields/worn_heater_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() function()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}

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
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);
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
		b.setValues(::Const.Tactical.Actor.BanditRaider);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_quick_hands"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Offhand))
		{
			local throwingWeapon = ::new("scripts/items/weapons/throwing_spear");
			this.getItems().addToBag(throwingWeapon);
		}
	}
});
