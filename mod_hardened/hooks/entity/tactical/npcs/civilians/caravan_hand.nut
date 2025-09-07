// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/caravan_hand", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/bludgeon"],
			[12, "scripts/items/weapons/hatchet"],
			[12, "scripts/items/weapons/militia_spear"],
			[12, "scripts/items/weapons/knife"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/wooden_shield_old"],
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
		this.getSprite("socket").setBrush("bust_base_caravan");
		this.getSprite("dirt").Visible = true;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.CaravanHand);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_bags_and_belts"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		local r = this.Math.rand(1, 4);
		if (r == 1)
		{
			this.getItems().equip(::new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			this.getItems().equip(::new("scripts/items/armor/thick_tunic"));
		}
		else if (r == 3)
		{
			this.getItems().equip(::new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 4)
		{
			local item = ::new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			this.getItems().equip(item);
		}

		if (this.Math.rand(1, 100) <= 33)
		{
			local r = this.Math.rand(1, 2);
			if (r == 1)
			{
				this.getItems().equip(::new("scripts/items/helmets/hood"));
			}
			else if (r == 2)
			{
				this.getItems().equip(::new("scripts/items/helmets/aketon_cap"));
			}
		}
	}
});
