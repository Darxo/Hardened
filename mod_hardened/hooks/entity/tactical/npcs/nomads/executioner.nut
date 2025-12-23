// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/executioner", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/lamellar_harness"],
			[12, "scripts/items/armor/heavy_lamellar_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/oriental/turban_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/two_handed_flail"],
			[12, "scripts/items/weapons/two_handed_flanged_mace"],
			[12, "scripts/items/weapons/two_handed_hammer"],
		]);

		this.m.AIAgent = ::new("scripts/ai/tactical/agents/hd_generic_carry_agent");
		this.m.AIAgent.setActor(this);
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
		if (r == 1)
		{
			local weapon = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/named/named_two_handed_flail"],
				[12, "scripts/items/weapons/named/named_two_handed_mace"],
				[12, "scripts/items/weapons/named/named_two_handed_hammer"],
			]).roll();
			this.getItems().equip(::new(weapon));
		}
		else if (r == 2)
		{
			this.getItems().equip(::new("scripts/items/" + ::MSU.Array.rand(::Const.Items.NamedSouthernArmors)));
		}
		else if (r == 3)
		{
			this.getItems().equip(::new("scripts/items/" + ::MSU.Array.rand(::Const.Items.NamedSouthernHelmets)));
		}

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vanquisher"));

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
			if (weapon.isWeaponType(::Const.Items.WeaponType.Flail))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_flail_spinner"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_deep_impact"));	// Breakthrough
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Mace))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_concussive_strikes"));		// Shockwave
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
		b.setValues(::Const.Tactical.Actor.Executioner);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tricksters_purses"));

		this.getSkills().add(::new("scripts/skills/perks/perk_coup_de_grace"));
		this.getSkills().add(::new("scripts/skills/perks/perk_killing_frenzy"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
