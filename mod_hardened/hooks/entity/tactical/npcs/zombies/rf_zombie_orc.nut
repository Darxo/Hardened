// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_zombie_orc", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ResurrectionChance = 100;	// Reforged: 66

		// Zombie Orcs use the same gear as their living counterparts
		local orcArmory = ::new("scripts/entity/tactical/enemies/orc_young");
		this.m.ChanceForNoChest = orcArmory.m.ChanceForNoChest;
		this.m.ChestWeightedContainer = orcArmory.m.ChestWeightedContainer;
		this.m.ChanceForNoHelmet = orcArmory.m.ChanceForNoHelmet;
		this.m.HelmetWeightedContainer = orcArmory.m.HelmetWeightedContainer;
		this.m.ChanceForNoWeapon = orcArmory.m.ChanceForNoWeapon;
		this.m.WeaponWeightContainer = orcArmory.m.WeaponWeightContainer;
		this.m.ChanceForNoOffhand = orcArmory.m.ChanceForNoOffhand;
		this.m.OffhandWeightContainer = orcArmory.m.OffhandWeightContainer;
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
		// This is an exact Reforged copy (with slighty better formatting), because we want to split sprit and skill initiatilisation
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("quiver");

		local body = this.addSprite("body");
		body.Saturation = 0.35;
		body.varySaturation(0.1);
		body.varyColor(0.05, 0.05, 0.05);

		local tattoo_body = this.addSprite("tattoo_body");
		tattoo_body.Saturation = 0.9;
		tattoo_body.setBrightness(0.75);

		local body_injury = this.addSprite("body_injury");
		body_injury.Visible = true;
		body_injury.setBrightness(0.75);

		this.addSprite("armor");
		this.addSprite("surcoat");
		this.addSprite("armor_upgrade_back");

		local body_blood_always = this.addSprite("body_blood_always");
		body_blood_always.setBrush("bust_body_bloodied_01");

		this.addSprite("shaft");

		local head = this.addSprite("head");
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		local tattoo_head = this.addSprite("tattoo_head");
		tattoo_head.Saturation = 0.9;
		tattoo_head.setBrightness(0.75);

		local injury = this.addSprite("injury");
		injury.setBrightness(0.75);

		this.addSprite("helmet");
		this.addSprite("helmet_damage");
		this.addSprite("armor_upgrade_front");

		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = ::Math.rand(1, 100) <= 33;

		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.Visible = ::Math.rand(1, 100) <= 50;

		local rage = this.addSprite("status_rage");
		rage.setBrush("mind_control");
		rage.Visible = false;

		this.addDefaultStatusSprites();
		this.getSprite("arms_icon").setBrightness(0.85);
		this.getSprite("status_rooted").Scale = 0.55;

		local armor = this.getSprite("armor");
		armor.setBrightness(0.75);
		armor.Saturation = 0.7;
		armor.varySaturation(0.2);

		local helmet = this.getSprite("helmet");
		helmet.setBrightness(0.75);
		helmet.Saturation = armor.Saturation;

		local helmet_damage = this.getSprite("helmet_damage");
		helmet_damage.setBrightness(0.75);
		helmet_damage.Saturation = armor.Saturation;

		this.setOrcSpecificSprites();

		local app = this.getItems().getAppearance();
		app.Body = body.getBrush().Name;
		app.Corpse = app.Body + "_dead";

		this.getSprite("injury").setBrush(this.getZombifyBrushNameHead());
		this.getSprite("body_injury").setBrush(this.getZombifyBrushNameBody());
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.OrcYoung);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_orc_racial"));
		this.getSkills().add(::new("scripts/skills/racial/rf_zombie_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_menacing"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_wear_them_down"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/rf_zombie_orc_bite_skill"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
	}
});
