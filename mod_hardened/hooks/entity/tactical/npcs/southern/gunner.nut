// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/gunner", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/oriental/handgonne"],
		]);
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

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_southern");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Gunner);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_poise"));

		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_crossbow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_combo"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_steady_brace"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_through_the_ranks"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		local banner = 13;
		if (!this.Tactical.State.isScenarioMode())
		{
			banner = this.World.FactionManager.getFaction(this.getFaction()).getBanner();
		}
		local armor = this.new("scripts/items/armor/oriental/linothorax");
		if (banner == 12) armor.setVariant(9);
		else if (banner == 13) armor.setVariant(10);
		else if (banner == 14) armor.setVariant(8);
		this.m.Items.equip(armor);

		local helmet = this.new("scripts/items/helmets/oriental/gunner_hat");
		this.m.Items.equip(helmet);
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		this.m.Items.equip(this.new("scripts/items/ammo/powder_bag"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/oriental/saif"));
	}
});
