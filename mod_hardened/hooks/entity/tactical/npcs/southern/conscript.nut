// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/conscript", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/scimitar"],
			[12, "scripts/items/weapons/oriental/firelance"],
			[12, "scripts/items/weapons/oriental/light_southern_mace"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/oriental/southern_light_shield"],
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
		this.getSprite("socket").setBrush("bust_base_southern");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Conscript);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_poise"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_shield_expert"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		local banner = 13;
		if (!this.Tactical.State.isScenarioMode())
		{
			banner = this.World.FactionManager.getFaction(this.getFaction()).getBanner();
		}

		if (this.Math.rand(1, 3) <= 2)
		{
			local armor = this.new("scripts/items/armor/oriental/linothorax");
			if (banner == 12) armor.setVariant(9);
			else if (banner == 13) armor.setVariant(10);
			else if (banner == 14) armor.setVariant(8);
			this.m.Items.equip(armor);
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/armor/oriental/southern_mail_shirt"));
		}

		local r = this.Math.rand(1, 3);
		if (r == 1)
		{
			local helmet = this.new("scripts/items/helmets/oriental/southern_head_wrap");
			if (banner == 12) helmet.setVariant(12);
			else if (banner == 13) helmet.setVariant(8);
			else if (banner == 14) helmet.setVariant(7);
			this.m.Items.equip(helmet);
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/oriental/wrapped_southern_helmet"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/oriental/spiked_skull_cap_with_mail"));
		}
	}
});





