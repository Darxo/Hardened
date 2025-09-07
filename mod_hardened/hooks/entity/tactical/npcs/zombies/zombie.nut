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

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		local app = this.getItems().getAppearance();
		app.Body = "bust_naked_body_0" + this.Math.rand(0, 2);
		app.Corpse = app.Body + "_dead";
		this.m.InjuryType = this.Math.rand(1, 4);
		local hairColor = this.Const.HairColors.Zombie[this.Math.rand(0, this.Const.HairColors.Zombie.len() - 1)];
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("quiver").setHorizontalFlipping(true);
		local body = this.addSprite("body");
		body.setHorizontalFlipping(true);
		body.setBrush(this.Const.Items.Default.PlayerNakedBody);
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
		head.setBrush(this.Const.Faces.AllMale[this.Math.rand(0, this.Const.Faces.AllMale.len() - 1)]);
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		local tattoo_head = this.addSprite("tattoo_head");
		tattoo_head.setHorizontalFlipping(true);
		tattoo_head.Saturation = 0.9;
		tattoo_head.setBrightness(0.75);

		local beard = this.addSprite("beard");
		beard.setHorizontalFlipping(true);
		beard.varyColor(0.02, 0.02, 0.02);
		if (this.Math.rand(1, 100) <= 50)
		{
			if (this.m.InjuryType == 4)
			{
				beard.setBrush("beard_" + hairColor + "_" + this.Const.Beards.ZombieExtended[this.Math.rand(0, this.Const.Beards.ZombieExtended.len() - 1)]);
				beard.setBrightness(0.9);
			}
			else
			{
				beard.setBrush("beard_" + hairColor + "_" + this.Const.Beards.Zombie[this.Math.rand(0, this.Const.Beards.Zombie.len() - 1)]);
			}
		}

		local injury = this.addSprite("injury");
		injury.setHorizontalFlipping(true);
		injury.setBrush("zombify_0" + this.m.InjuryType);
		injury.setBrightness(0.75);

		local hair = this.addSprite("hair");
		hair.setHorizontalFlipping(true);
		hair.Color = beard.Color;
		if (this.Math.rand(0, this.Const.Hair.Zombie.len()) != this.Const.Hair.Zombie.len())
		{
			hair.setBrush("hair_" + hairColor + "_" + this.Const.Hair.Zombie[this.Math.rand(0, this.Const.Hair.Zombie.len() - 1)]);
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
		body_blood.Visible = this.Math.rand(1, 100) <= 33;

		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.setHorizontalFlipping(true);
		body_dirt.Visible = this.Math.rand(1, 100) <= 50;

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
});
