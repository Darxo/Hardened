// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/oathbringer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/adorned_heavy_mail_hauberk"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/adorned_closed_flat_top_with_mail"],
			[12, "scripts/items/helmets/adorned_full_helm"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/bardiche"],
			[12, "scripts/items/weapons/greatsword"],
			[12, "scripts/items/weapons/two_handed_flanged_mace"],
			[12, "scripts/items/weapons/two_handed_hammer"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		local r = ::Math.rand(1, 3);
		if (r == 1)
		{
			local weapon = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/named/named_bardiche"],
				[12, "scripts/items/weapons/named/named_greatsword"],
				[12, "scripts/items/weapons/named/named_two_handed_mace"],
				[12, "scripts/items/weapons/named/named_two_handed_hammer"],
			]).roll();
			this.getItems().equip(::new(weapon));
		}
		else if (r == 2)
		{
			local armor = ::Reforged.ItemTable.NamedArmorNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax < 280) return 0.0;
					return _weight;
				}
			})
			if (armor != null) this.getItems().equip(::new(armor));
		}
		else
		{
			local helmet = ::Reforged.ItemTable.NamedHelmetNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax < 280) return 0.0;
					return _weight;
				}
			})
			if (helmet != null) this.getItems().equip(::new(helmet));
		}

		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		return true;
	}}.makeMiniboss;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);

		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Axe))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_dismemberment"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_dismantle"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_deep_impact"));	// Breakthrough
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_rattle"));			// Full Force
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_combo"));		// To help with the full force eating all AP leaving none for berserk
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Mace))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_concussive_strikes"));		// Shockwave
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_bone_breaker"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_tempo"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_en_garde"));
			}
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_military");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Oathbringer);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_fresh_and_furious"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_savage_strength"));
		this.getSkills().add(::new("scripts/skills/perks/perk_berserk"));
		this.getSkills().add(::new("scripts/skills/perks/perk_killing_frenzy"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
