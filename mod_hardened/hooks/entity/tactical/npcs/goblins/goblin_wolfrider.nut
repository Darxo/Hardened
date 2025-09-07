// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_wolfrider", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_spear"],
			[12, "scripts/items/weapons/greenskins/goblin_falchion"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.goblin.onInit();
	}}.onInit;

// Hardened Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites = @(__original) function()
	{
		__original();
		this.getSprite("head").setBrush("bust_goblin_01_head_0" + this.Math.rand(1, 3));
		this.setAlwaysApplySpriteOffset(true);
		local offset = this.createVec(8, 14);
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("armor", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("helmet", offset);
		this.setSpriteOffset("helmet_damage", offset);
		this.setSpriteOffset("body_blood", offset);
		local variant = this.Math.rand(1, 2);
		local wolf = this.addSprite("wolf");
		wolf.setBrush("bust_wolf_0" + variant + "_body");
		wolf.varySaturation(0.15);
		wolf.varyColor(0.07, 0.07, 0.07);
		local wolf = this.addSprite("wolf_head");
		wolf.setBrush("bust_wolf_0" + variant + "_head");
		wolf.Saturation = wolf.Saturation;
		wolf.Color = wolf.Color;
		this.removeSprite("injury_body");
		local wolf_injury = this.addSprite("injury_body");
		wolf_injury.setBrush("bust_wolf_01_injured");
		wolf_injury.Visible = false;
		local wolf_armor = this.addSprite("wolf_armor");
		wolf_armor.setBrush("bust_wolf_02_armor_01");
		offset = this.createVec(0, -20);
		this.setSpriteOffset("wolf", offset);
		this.setSpriteOffset("wolf_head", offset);
		this.setSpriteOffset("wolf_armor", offset);
		this.setSpriteOffset("injury_body", offset);
		this.addDefaultStatusSprites();
		this.setSpriteOffset("arms_icon", this.createVec(15, 15));
		this.getSprite("arms_icon").Rotation = 13.0;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.GoblinWolfrider);
		b.TargetAttractionMult = 0.1;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_goblin_wolfrider_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));

		// Generic Actives
		local wolf_bite = ::new("scripts/skills/actives/wolf_bite");
		wolf_bite.setRestrained(true);
		wolf_bite.m.ActionPointCost = 0;
		this.getSkills().add(wolf_bite);
		// In vanilla goblin_wolfriders have a bug that they get the bonus damage from wolf_bite for ALL attacks
		// until they use that skill. Reforged has "fixed" that in the hook on wolf_bite.
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		if (this.Math.rand(1, 100) <= 75)
		{
			this.getItems().equip(::new("scripts/items/armor/greenskins/goblin_medium_armor"));
		}
		else
		{
			this.getItems().equip(::new("scripts/items/armor/greenskins/goblin_heavy_armor"));
		}

		if (this.Math.rand(1, 100) <= 75)
		{
			this.getItems().equip(::new("scripts/items/helmets/greenskins/goblin_light_helmet"));
		}
		else
		{
			this.getItems().equip(::new("scripts/items/helmets/greenskins/goblin_heavy_helmet"));
		}
	}
});
