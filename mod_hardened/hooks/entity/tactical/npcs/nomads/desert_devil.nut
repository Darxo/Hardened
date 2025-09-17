// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/desert_devil", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/oriental/assassin_robe"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/oriental/blade_dancer_head_wrap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/shamshir"],
			[12, "scripts/items/weapons/oriental/swordlance"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		local r = ::Math.rand(1, 3);
		if (r <= 2)
		{
			local weapon = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/named/named_shamshir"],
				[12, "scripts/items/weapons/named/named_swordlance"],
			]).roll();
			this.getItems().equip(::new(weapon));
		}
		else if (r == 3)
		{
			this.getItems().equip(::new("scripts/items/armor/named/black_leather_armor"));
		}

		this.getSkills().add(::new("scripts/skills/perks/perk_coup_de_grace"));
		return true;
	}}.makeMiniboss;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);

		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Polearm))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_long_reach"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_leverage"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_tempo"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_unstoppable"));
			}
		}
	}

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
		b.setValues(::Const.Tactical.Actor.DesertDevil);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tricksters_purses"));

		this.getSkills().add(::new("scripts/skills/perks/perk_battle_flow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_relentless"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
