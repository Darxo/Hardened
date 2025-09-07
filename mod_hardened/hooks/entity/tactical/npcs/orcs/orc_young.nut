// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/orc_young", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/morning_star"],
			[12, "scripts/items/weapons/greenskins/orc_metal_club"],
			[12, "scripts/items/weapons/greenskins/orc_wooden_club"],
		]);

		this.m.ChanceForNoOffhand = 50;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/greenskins/orc_light_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

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
		this.m.Items.getAppearance().Body = "bust_orc_01_body";
		this.addSprite("socket").setBrush("bust_base_orcs");
		local body = this.addSprite("body");
		body.setBrush("bust_orc_01_body");
		body.varySaturation(0.05);
		body.varyColor(0.07, 0.07, 0.07);
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_01_body_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_orc_01_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_01_head_injured");
		this.addSprite("helmet");
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_orc_01_body_bloodied");
		body_blood.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.OrcYoung);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_orc_racial"));
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(this.new("scripts/skills/effects/captain_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_berserk"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_mace"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_concussive_strikes"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand_orc"));
		this.getSkills().add(::new("scripts/skills/actives/wake_ally_skill"));
		this.getSkills().add(this.new("scripts/skills/actives/charge"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		local r = this.Math.rand(1, 5);
		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_very_light_armor"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_light_armor"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_medium_armor"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/armor/greenskins/orc_young_heavy_armor"));
		}

		r = this.Math.rand(1, 4);
		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_young_light_helmet"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_young_medium_helmet"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/orc_young_heavy_helmet"));
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		if (this.Math.rand(1, 100) <= 25)
		{
			local sidearm = ::new(::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/greenskins/orc_javelin"],
			]).roll());
			sidearm.m.Ammo = 3;
			this.getItems().addToBag((sidearm));
		}
	}
});
