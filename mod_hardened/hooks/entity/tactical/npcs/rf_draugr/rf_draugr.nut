::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_draugr", function(q) {
	// Overwrite, because we dont want to add extra perks in this base function
	q.onInit = @() function()
	{
		this.actor.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}

// Reforged Functions
	// Overwrite, because we dont want to add any of the reforged perks and skills
	q.onSpawned = @() function()
	{
	}

// New Functions
	q.HD_onInitSprites <- function()
	{
		// Copy of Reforged Draugr SpriteInit, as that is the easiest way to cleanly separate Spritework from Skills/Stats
		local app = this.getItems().getAppearance();
		local bodyBrush = this.getBodyBrushName();

		app.Body = bodyBrush;
		app.Corpse = app.Body + "_dead";
		this.m.InjuryType = ::Math.rand(1, 9);
		local hairColor = ::MSU.Array.rand(::Const.HairColors.RF_Draugr);
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_rf_draugr_01");
		this.addSprite("quiver").setHorizontalFlipping(true);

		local body = this.addSprite("body");
		body.setHorizontalFlipping(true);
		body.setBrush(bodyBrush);
		body.setBrightness(0.85);
		body.Saturation = 0.2;
		body.varySaturation(0.1);
		body.Color = this.createColor("#f9e3ff");
		body.varyColor(0.05, 0.05, 0.05);

		local draugr_body = this.addSprite("rf_draugr_body");
		draugr_body.Visible = ::Math.rand(1, 100) <= 70;
		draugr_body.setHorizontalFlipping(true);
		draugr_body.setBrightness(0.75);
		draugr_body.setBrush("rf_draugr_body_layer_0" + ::Math.rand(1, 3));

		local tattoo_body = this.addSprite("tattoo_body");
		tattoo_body.setHorizontalFlipping(true);
		tattoo_body.Saturation = 0.9;
		tattoo_body.setBrightness(0.75);
		if (::Math.rand(1, 100) <= 50) tattoo_body.setBrush("rf_draugr_tattoo_body_0" + ::Math.rand(1, 4));

		local body_injury = this.addSprite("body_injury");
		body_injury.setBrush("zombify_body_02");
		body_injury.Saturation = body.Saturation * 2;
		body_injury.Visible = false;

		this.addSprite("armor").setHorizontalFlipping(true);
		this.addSprite("surcoat");

		local body_detail = this.addSprite("body_detail");
		body_detail.setHorizontalFlipping(true);
		if (::Math.rand(1, 100) <= 33) body_detail.setBrush("rf_draugr_accessory_0" + ::Math.rand(1, 3));

		this.addSprite("armor_upgrade_back");
		local body_blood_always = this.addSprite("body_blood_always");
		body_blood_always.setBrush("bust_body_bloodied_01");
		body_blood_always.setHorizontalFlipping(true);
		body_blood_always.Visible = ::Math.rand(1, 100) <= 33;
		body_blood_always.Saturation = body.Saturation * 2;

		this.addSprite("shaft");
		local head = this.addSprite("head");
		head.setHorizontalFlipping(true);
		head.setBrush(::Const.Faces.SmartMale[::Math.rand(0, ::Const.Faces.SmartMale.len() - 1)]);
		head.Saturation = body.Saturation;
		head.Color = body.Color;

		local draugr_head = this.addSprite("rf_draugr_head");
		draugr_head.setHorizontalFlipping(true);
		draugr_head.setBrush("rf_draugr_head_layer_0" + this.m.InjuryType);
		draugr_head.setBrightness(0.75);

		local tattoo_head = this.addSprite("tattoo_head");
		tattoo_head.setHorizontalFlipping(true);
		tattoo_head.Saturation = 0.9;
		tattoo_head.setBrightness(0.75);
		if (::Math.rand(1, 100) <= 50) tattoo_head.setBrush("rf_draugr_tattoo_head_0" + ::Math.rand(1, 5));

		local beard = this.addSprite("beard");
		beard.setHorizontalFlipping(true);
		beard.varyColor(0.02, 0.02, 0.02);

		if (::Math.rand(1, 100) <= 50) beard.setBrush("beard_" + hairColor + "_" + ::Const.Beards.ZombieOnly[::Math.rand(0, ::Const.Beards.ZombieOnly.len() - 1)]);

		local injury = this.addSprite("injury");
		injury.setHorizontalFlipping(true);
		injury.setBrightness(0.75);
		injury.Saturation = body.Saturation * 2;
		injury.Visible = false;

		local hair = this.addSprite("hair");
		hair.setHorizontalFlipping(true);
		hair.Color = beard.Color;

		if (::Math.rand(1, 100) <= 50) hair.setBrush("hair_" + hairColor + "_" + ::MSU.Array.rand(::Const.Hair.Vampire));

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
		this.m.ExcludedInjuries.extend(::Const.Injury.ExcludedInjuries.get(::Const.Injury.ExcludedInjuries.RF_Undead));

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_DraugrThrall);
		b.IsAffectedByNight = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand"));
		this.getSkills().add(::new("scripts/skills/racial/rf_draugr_racial"));
		this.getSkills().add(::new("scripts/skills/effects/rf_frostbound_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));

		// Generic Actives
	}
});
