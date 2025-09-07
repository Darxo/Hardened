// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/officer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/shamshir"],
			[12, "scripts/items/weapons/oriental/heavy_southern_mace"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/oriental/metal_round_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

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
		b.setValues(::Const.Tactical.Actor.Officer);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_poise"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::Reforged.new("scripts/skills/perks/perk_rally_the_troops", function(o) {
			o.m.ActionPointCost = 3;
		}));
		this.getSkills().add(::new("scripts/skills/perks/perk_inspiring_presence"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_shield_sergeant"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_the_rush_of_battle"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
		{
			local r = this.Math.rand(1, 3);

			if (r == 1)
			{
				this.getItems().equip(::new("scripts/items/armor/oriental/padded_mail_and_lamellar_hauberk"));
			}
			else if (r == 2)
			{
				this.getItems().equip(::new("scripts/items/armor/oriental/southern_long_mail_with_padding"));
			}
			else if (r == 3)
			{
				this.getItems().equip(::new("scripts/items/armor/oriental/mail_and_lamellar_plating"));
			}
		}

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			local r = this.Math.rand(1, 3);

			if (r == 1)
			{
				this.getItems().equip(::new("scripts/items/helmets/oriental/turban_helmet"));
			}
			else if (r == 2)
			{
				this.getItems().equip(::new("scripts/items/helmets/oriental/heavy_lamellar_helmet"));
			}
			else if (r == 3)
			{
				this.getItems().equip(::new("scripts/items/helmets/oriental/southern_helmet_with_coif"));
			}
		}
	}
});
