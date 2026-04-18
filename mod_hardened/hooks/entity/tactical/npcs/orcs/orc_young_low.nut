// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/orc_young_low", function(q) {
	q.create = @(__original) function()
	{
		// Switcheroo the OrcYoung ID into that of HD_OrcYoung, to make the base class assign the ID, that we want
		// Overwriting the base.create is too much work
		local oldEntityType = ::Const.EntityType.OrcYoung;
		::Const.EntityType.OrcYoung = ::Const.EntityType.HD_OrcYoung;
		__original();
		::Const.EntityType.OrcYoung = oldEntityType;

		this.m.ChanceForNoChest = 40;
		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/greenskins/orc_young_very_light_armor"],
			[12, "scripts/items/armor/greenskins/orc_young_light_armor"],
		]);

		this.m.ChanceForNoHelmet = 60;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/greenskins/orc_young_light_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[6, "scripts/items/weapons/hand_axe"],
			[6, "scripts/items/weapons/morning_star"],
			[6, "scripts/items/weapons/scramasax"],
			[12, "scripts/items/weapons/greenskins/orc_wooden_club"],
		]);

		this.m.ChanceForNoOffhand = 50;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/greenskins/orc_light_shield"],
		]);
	}

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// New Functions

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.HD_OrcYoung);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/rf_orc_racial"));
		this.getSkills().add(::new("scripts/skills/special/double_grip"));
		this.getSkills().add(::new("scripts/skills/effects/captain_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_berserk"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/hand_to_hand_orc"));
		this.getSkills().add(::new("scripts/skills/actives/wake_ally_skill"));
		this.getSkills().add(::new("scripts/skills/actives/charge"));
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local offhand = this.getOffhandItem();
		if (offhand == null || !offhand.isItemType(::Const.Items.ItemType.Shield))
		{
			// Only orcs without shields get a throwing weapon, as they are usually less resilient in direct melee contact
			local sidearm = ::new(::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/greenskins/orc_javelin"],
			]).roll());
			sidearm.m.Ammo = 1;
			this.getItems().addToBag((sidearm));
		}
	}
});
