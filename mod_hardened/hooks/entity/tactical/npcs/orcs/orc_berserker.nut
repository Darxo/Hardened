// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/orc_berserker", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChanceForNoChest = 66;
		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/greenskins/orc_berserker_light_armor"],
			[12, "scripts/items/armor/greenskins/orc_berserker_medium_armor"],
		]);

		this.m.ChanceForNoHelmet = 66;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/greenskins/orc_berserker_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/orc_flail_2h"],
			[12, "scripts/items/weapons/greenskins/orc_axe_2h"],
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
		this.getItems().getAppearance().Body = "bust_orc_02_body";
		this.addSprite("socket").setBrush("bust_base_orcs");
		local body = this.addSprite("body");
		body.setBrush("bust_orc_02_body");
		body.varySaturation(0.1);
		body.varyColor(0.08, 0.08, 0.08);

		local tattoo_body = this.addSprite("tattoo_body");
		if (this.Math.rand(1, 100) <= 50)
		{
			tattoo_body.setBrush("bust_orc_02_body_paint_0" + this.Math.rand(1, 3));
		}

		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_02_body_injured");

		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_orc_02_head_0" + this.Math.rand(1, 3));
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		local tattoo_head = this.addSprite("tattoo_head");
		if (this.Math.rand(1, 100) <= 50)
		{
			tattoo_head.setBrush("bust_orc_02_head_paint_0" + this.Math.rand(1, 3));
		}

		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_orc_02_head_injured");

		this.addSprite("helmet");
		local body_rage = this.addSprite("body_rage");
		body_rage.Visible = false;
		body_rage.Alpha = 220;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.6;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.OrcBerserker);
		b.IsAffectedByFreshInjuries = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_orc_racial"));
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(::new("scripts/skills/effects/captain_effect"));
		this.getSkills().add(::new("scripts/skills/effects/berserker_rage_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_berserk"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));

		this.getSkills().add(::new("scripts/skills/perks/perk_battering_ram"));
		this.getSkills().add(::new("scripts/skills/perks/perk_killing_frenzy"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand_orc"));
		this.getSkills().add(::new("scripts/skills/actives/wake_ally_skill"));
		this.getSkills().add(::new("scripts/skills/actives/charge"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
