// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/nomad_outlaw", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/oriental/stitched_nomad_armor"],
			[12, "scripts/items/armor/oriental/plated_nomad_mail"],
			[12, "scripts/items/armor/oriental/leather_nomad_robe"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/oriental/nomad_leather_cap"],
			[12, "scripts/items/helmets/oriental/nomad_light_helmet"],
			[12, "scripts/items/helmets/oriental/nomad_reinforced_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[4, "scripts/items/weapons/battle_whip"],	// Todo: find a better enemy for this type of weapon
			[12, "scripts/items/weapons/scimitar"],
			[12, "scripts/items/weapons/three_headed_flail"],
			[12, "scripts/items/weapons/two_handed_wooden_hammer"],
			[12, "scripts/items/weapons/oriental/polemace"],
			[12, "scripts/items/weapons/oriental/two_handed_saif"],
		]);

		this.m.ChanceForNoOffhand = 33;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/oriental/southern_light_shield"],
			[12, "scripts/items/shields/oriental/metal_round_shield"],
		]);

		this.m.AIAgent = ::new("scripts/ai/tactical/agents/hd_nomad_melee_agent");
		this.m.AIAgent.setActor(this);
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

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);
		::Hardened.util.preSwapRangedWeapon(this);
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_nomads");
		if (this.Math.rand(1, 100) <= 15)
		{
			local pox = this.getSprite("tattoo_head");
			pox.Visible = true;
			pox.setBrush("bust_head_darkeyes_01");
		}
		else
		{
			local dirt = this.getSprite("dirt");
			dirt.Visible = true;
		}
		if (this.Math.rand(1, 100) <= 25)
		{
			this.getSprite("eye_rings").Visible = true;
		}
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.NomadOutlaw);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tricksters_purses"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_hybridization"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_hybridization"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		if (::Math.rand(1, 100) <= 40)
		{
			local sidearm = ::new(::MSU.Class.WeightedContainer([
				[1, "scripts/items/weapons/javelin"],
			]).roll());
			sidearm.m.Ammo = 1;
			this.getItems().addToBag(sidearm);
		}
	}
});
