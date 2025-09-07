// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/desert_stalker", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/war_bow"],
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
		this.HD_assignOtherGear();
	}}.assignRandomEquipment;

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_nomads");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.DesertStalker);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tricksters_purses"));

		this.getSkills().add(::new("scripts/skills/perks/perk_battle_flow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_bow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_target_practice"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_combo"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_trick_shooter"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_scout"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor = [
				"scripts/items/armor/oriental/plated_nomad_mail",
			];
			this.getItems().equip(::new(armor[this.Math.rand(0, armor.len() - 1)]));
		}

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			local helmet = [
				"scripts/items/helmets/oriental/desert_stalker_head_wrap",
			];
			this.getItems().equip(::new(helmet[this.Math.rand(0, helmet.len() - 1)]));
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		this.getItems().equip(::new("scripts/items/ammo/quiver_of_arrows"));

		local sidearm = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/oriental/light_southern_mace"],
			[12, "scripts/items/weapons/scimitar"],
		]).roll();
		this.getItems().addToBag(::new(sidearm));
	}
});
