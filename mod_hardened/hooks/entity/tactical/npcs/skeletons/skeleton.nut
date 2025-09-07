// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/skeleton", function(q) {
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
		local hairColor = ::Const.HairColors.Zombie[this.Math.rand(0, ::Const.HairColors.Zombie.len() - 1)];
		this.addSprite("socket").setBrush("bust_base_undead");
		local body = this.addSprite("body");
		body.setBrush("bust_skeleton_body_0" + this.Math.rand(1, 2));
		body.setHorizontalFlipping(true);
		body.Saturation = 0.8;
		body.varySaturation(0.2);
		body.varyColor(0.025, 0.025, 0.025);
		this.m.BloodColor = body.Color;
		this.m.BloodSaturation = body.Saturation;
		this.addSprite("body_injury").setBrush("bust_skeleton_body_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_skeleton_head");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.setBrush("bust_skeleton_head_injured");
		local beard = this.addSprite("beard");
		beard.varyColor(0.02, 0.02, 0.02);

		if (this.Math.rand(1, 100) <= 25)
		{
			beard.setBrush("beard_" + hairColor + "_" + ::Const.Beards.ZombieOnly[this.Math.rand(0, ::Const.Beards.ZombieOnly.len() - 1)]);
		}

		local face = this.addSprite("face");
		face.setBrush("bust_skeleton_face_0" + this.Math.rand(1, 6));
		local hair = this.addSprite("hair");
		hair.setHorizontalFlipping(true);
		hair.Color = beard.Color;

		if (this.Math.rand(1, 100) <= 50)
		{
			hair.setBrush("hair_" + hairColor + "_" + ::Const.Hair.ZombieOnly[this.Math.rand(0, ::Const.Hair.ZombieOnly.len() - 1)]);
		}

		this.setSpriteOffset("hair", this.createVec(0, -3));
		this.addSprite("helmet");
		this.addSprite("helmet_damage");
		local beard_top = this.addSprite("beard_top");

		if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
		{
			beard_top.setBrush(beard.getBrush().Name + "_top");
			beard_top.Color = beard.Color;
		}

		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.setHorizontalFlipping(true);
		body_blood.Visible = false;
		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.setHorizontalFlipping(true);
		body_dirt.Visible = this.Math.rand(1, 100) <= 33;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		// b.setValues(::Const.Tactical.Actor.BLUE_PRINT);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/skeleton_racial"));
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(::new("scripts/skills/effects/rf_decanus_command_effect"));
		this.getSkills().add(::new("scripts/skills/effects/rf_centurion_command_effect"));
		this.getSkills().add(::new("scripts/skills/effects/rf_legatus_command_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_calculated_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_phalanx"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand"));
	}
});
