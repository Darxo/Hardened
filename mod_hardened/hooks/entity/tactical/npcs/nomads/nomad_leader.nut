// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/nomad_leader", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/light_scale_armor"],
			[12, "scripts/items/armor/oriental/southern_long_mail_with_padding"],
			[12, "scripts/items/armor/lamellar_harness"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/oriental/southern_helmet_with_coif"],
			[12, "scripts/items/helmets/steppe_helmet_with_mail"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/fighting_spear"],
			[12, "scripts/items/weapons/oriental/heavy_southern_mace"],
			[12, "scripts/items/weapons/oriental/two_handed_scimitar"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/oriental/metal_round_shield"],
		]);

		this.m.AIAgent = ::new("scripts/ai/tactical/agents/hd_generic_melee_leader_agent");
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

		local r = ::Math.rand(1, 4);
		if (r == 1)
		{
			local namedMeleeWeapon = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/named/named_spear"],
				[12, "scripts/items/weapons/named/named_mace"],
				[12, "scripts/items/weapons/named/named_two_handed_scimitar"],
			]).roll();
			this.getItems().equip(::new(namedMeleeWeapon));
		}
		else if (r == 2)
		{
			this.getItems().equip(::new("scripts/items/" + ::MSU.Array.rand(::Const.Items.NamedSouthernShields)));
			this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/fighting_spear"],
				[12, "scripts/items/weapons/oriental/heavy_southern_mace"],
			]);
		}
		else if (r == 3)
		{
			this.getItems().equip(::new("scripts/items/" + ::MSU.Array.rand(::Const.Items.NamedSouthernArmors)));
		}
		else
		{
			this.getItems().equip(::new("scripts/items/" + ::MSU.Array.rand(::Const.Items.NamedSouthernHelmets)));
		}

		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));

		return true;
	}}.makeMiniboss;

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

		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isItemType(::Const.Items.ItemType.OneHanded))	// + Shield
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_shield_expert"));
			}
			else
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_sweeping_strikes"));
			}
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_nomads");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = this.Math.rand(150, 255);
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.NomadLeader);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tricksters_purses"));

		this.getSkills().add(::Reforged.new("scripts/skills/perks/perk_rally_the_troops", function(o) {
			o.m.ActionPointCost = 3;
		}));
		this.getSkills().add(::new("scripts/skills/perks/perk_inspiring_presence"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_hybridization"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_hybridization"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_onslaught"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local sidearm = ::new(::MSU.Class.WeightedContainer([
			[1, "scripts/items/weapons/javelin"],
		]).roll());
		sidearm.m.Ammo = 1;
		this.getItems().addToBag(sidearm);
	}
});
