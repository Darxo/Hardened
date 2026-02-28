// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie", function(q) {
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

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		local app = this.getItems().getAppearance();
		app.Body = "bust_naked_body_0" + ::Math.rand(0, 2);
		app.Corpse = app.Body + "_dead";
		this.m.InjuryType = ::Math.rand(1, 4);
		local hairColor = ::Const.HairColors.Zombie[::Math.rand(0, ::Const.HairColors.Zombie.len() - 1)];
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("quiver").setHorizontalFlipping(true);
		local body = this.addSprite("body");
		body.setHorizontalFlipping(true);
		body.setBrush(::Const.Items.Default.PlayerNakedBody);
		body.Saturation = 0.5;
		body.varySaturation(0.2);
		body.Color = this.createColor("#c1ddaa");
		body.varyColor(0.05, 0.05, 0.05);

		local tattoo_body = this.addSprite("tattoo_body");
		tattoo_body.setHorizontalFlipping(true);
		tattoo_body.Saturation = 0.9;
		tattoo_body.setBrightness(0.75);

		local body_injury = this.addSprite("body_injury");
		body_injury.Visible = true;
		body_injury.setBrightness(0.75);
		body_injury.setBrush("zombify_body_01");

		this.addSprite("armor").setHorizontalFlipping(true);
		this.addSprite("surcoat");
		this.addSprite("armor_upgrade_back");

		local body_blood_always = this.addSprite("body_blood_always");
		body_blood_always.setBrush("bust_body_bloodied_01");

		this.addSprite("shaft");

		local head = this.addSprite("head");
		head.setHorizontalFlipping(true);
		head.setBrush(::Const.Faces.AllMale[::Math.rand(0, ::Const.Faces.AllMale.len() - 1)]);
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		local tattoo_head = this.addSprite("tattoo_head");
		tattoo_head.setHorizontalFlipping(true);
		tattoo_head.Saturation = 0.9;
		tattoo_head.setBrightness(0.75);

		local beard = this.addSprite("beard");
		beard.setHorizontalFlipping(true);
		beard.varyColor(0.02, 0.02, 0.02);
		if (::Math.rand(1, 100) <= 50)
		{
			if (this.m.InjuryType == 4)
			{
				beard.setBrush("beard_" + hairColor + "_" + ::Const.Beards.ZombieExtended[::Math.rand(0, ::Const.Beards.ZombieExtended.len() - 1)]);
				beard.setBrightness(0.9);
			}
			else
			{
				beard.setBrush("beard_" + hairColor + "_" + ::Const.Beards.Zombie[::Math.rand(0, ::Const.Beards.Zombie.len() - 1)]);
			}
		}

		local injury = this.addSprite("injury");
		injury.setHorizontalFlipping(true);
		injury.setBrush("zombify_0" + this.m.InjuryType);
		injury.setBrightness(0.75);

		local hair = this.addSprite("hair");
		hair.setHorizontalFlipping(true);
		hair.Color = beard.Color;
		if (::Math.rand(0, ::Const.Hair.Zombie.len()) != ::Const.Hair.Zombie.len())
		{
			hair.setBrush("hair_" + hairColor + "_" + ::Const.Hair.Zombie[::Math.rand(0, ::Const.Hair.Zombie.len() - 1)]);
		}

		this.addSprite("helmet").setHorizontalFlipping(true);
		this.addSprite("helmet_damage").setHorizontalFlipping(true);
		local beard_top = this.addSprite("beard_top");
		beard_top.setHorizontalFlipping(true);
		if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
		{
			beard_top.setBrush(beard.getBrush().Name + "_top");
			beard_top.Color = beard.Color;
		}

		this.addSprite("armor_upgrade_front");

		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.setHorizontalFlipping(true);
		body_blood.Visible = ::Math.rand(1, 100) <= 33;

		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.setHorizontalFlipping(true);
		body_dirt.Visible = ::Math.rand(1, 100) <= 50;

		local rage = this.addSprite("status_rage");
		rage.setHorizontalFlipping(true);
		rage.setBrush("mind_control");
		rage.Visible = false;

		this.addDefaultStatusSprites();
		this.getSprite("arms_icon").setBrightness(0.85);
		this.getSprite("status_rooted").Scale = 0.55;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Zombie);
		this.m.MaxResurrectDelay = 3;		// Vanilla: 2
		this.m.ResurrectionChance = 100;	// Vanilla: 66

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_zombie_racial"));
		// this.getSkills().add(::new("scripts/skills/special/double_grip"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_wear_them_down"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/zombie_bite"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		local armor = ::new(::MSU.Class.WeightedContainer([
			[1, "scripts/items/armor/leather_tunic"],
			[2, "scripts/items/armor/linen_tunic"],
			[1, "scripts/items/armor/sackcloth"],
			[1, "scripts/items/armor/tattered_sackcloth"],
			[1, "scripts/items/armor/leather_wraps"],
			[1, "scripts/items/armor/apron"],
			[1, "scripts/items/armor/butcher_apron"],
			[1, "scripts/items/armor/monk_robe"],
		]).roll());
		if (::Math.rand(1, 100) <= 50)
		{
			armor.setArmor(::Math.round(armor.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(armor);

		if (::Math.rand(1, 100) <= 33)
		{
			local helmet = ::new(::MSU.Class.WeightedContainer([
				[1, "scripts/items/helmets/hood"],
				[1, "scripts/items/helmets/aketon_cap"],
				[1, "scripts/items/helmets/full_aketon_cap"],
				[1, "scripts/items/helmets/open_leather_cap"],
				[1, "scripts/items/helmets/full_leather_cap"],
			]).roll());
			if (::Math.rand(1, 100) <= 50)
			{
				helmet.setArmor(::Math.round(helmet.getArmorMax() / 2 - 1) / 1.0);
			}
			this.getItems().equip(helmet);
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		// We have to assign the weapon here, instead of using WeaponWeightContainer, because the alternative would force default zombie weapons on anything inheriting from zombie.nut
		// Anything inheriting this would otherwise need to reming themselves to set the chance for no-weapon to 0. And modded enemies dont know about this
		if (::Math.rand(1, 2) == 1)
		{
			this.getItems().equip(::new(::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/pickaxe"],
				[12, "scripts/items/weapons/pitchfork"],
				[12, "scripts/items/weapons/militia_spear"],
				[12, "scripts/items/weapons/butchers_cleaver"],
				[12, "scripts/items/weapons/hatchet"],
			]).roll()));
		}
	}
});
