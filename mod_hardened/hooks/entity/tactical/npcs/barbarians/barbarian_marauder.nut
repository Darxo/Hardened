// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/barbarian_marauder", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/barbarians/axehammer"],
			[12, "scripts/items/weapons/barbarians/blunt_cleaver"],
			[12, "scripts/items/weapons/barbarians/crude_axe"],
			[12, "scripts/items/weapons/barbarians/skull_hammer"],
			[12, "scripts/items/weapons/barbarians/two_handed_spiked_mace"],
		]);

		this.m.ChanceForNoOffhand = 75;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/wooden_shield_old"],
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

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_wildmen_01");
		local tattoos = [3,	4, 5, 6];
		if (this.Math.rand(1, 100) <= 66)
		{
			local tattoo_body = this.actor.getSprite("tattoo_body");
			local body = this.actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + ::MSU.Array.rand(tattoos) + "_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			local tattoo_head = this.actor.getSprite("tattoo_head");
			tattoo_head.setBrush("tattoo_0" + ::MSU.Array.rand(tattoos) + "_head");
			tattoo_head.Visible = true;
		}
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.BarbarianMarauder);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_adrenalin"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/barbarian_fury_skill"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		local r = this.Math.rand(1, 3);
		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/barbarians/hide_and_bone_armor"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/armor/barbarians/reinforced_animal_hide_armor"));
		}

		r = this.Math.rand(1, 5);
		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/barbarians/leather_headband"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/barbarians/bear_headpiece"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/barbarians/leather_helmet"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/barbarians/crude_metal_helmet"));
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		if (::Math.rand(1, 100) <= 40)
		{
			local throwingWeapon = ::new(::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/barbarians/heavy_throwing_axe"],
				[12, "scripts/items/weapons/barbarians/heavy_javelin"],
			]).roll());
			throwingWeapon.m.Ammo = 3;
			this.getItems().addToBag(throwingWeapon);
		}
	}
});
