// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/noble_sergeant", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/fighting_axe"],
			[12, "scripts/items/weapons/military_cleaver"],
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
		this.getSprite("socket").setBrush("bust_base_military");
		this.getSprite("accessory_special").setBrush("sergeant_trophy");

		local suffix = ::MSU.Array.rand([1, 2, 4]);
		local sprite = this.getSprite("permanent_injury_" + suffix);
		sprite.setBrush("permanent_injury_0" + suffix);
		sprite.Visible = true;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Sergeant);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_steel_brow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_the_rush_of_battle"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_exude_confidence"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_parry"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_hold_steady"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
			local script = ::MSU.Class.WeightedContainer([
				[1, "scripts/items/armor/mail_hauberk"],
				[1, "scripts/items/armor/reinforced_mail_hauberk"],
			]).roll();

			local armor = ::new(script);
			if (script == "scripts/items/armor/mail_hauberk")
				armor.setVariant(28);

			this.m.Items.equip(armor);
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local banner = ::Tactical.State.isScenarioMode() ? this.getFaction() : ::World.FactionManager.getFaction(this.getFaction()).getBanner();
		this.m.Surcoat = banner;
		if (::Math.rand(1, 100) <= this.m.SurcoatChance)
		{
			this.getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));
		}
	}
});
