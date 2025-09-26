// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([	// 110 - 135
			[12, "scripts/items/armor/rf_brigandine_shirt"],
			[12, "scripts/items/armor/noble_mail_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 60
			[12, "scripts/items/helmets/greatsword_hat"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/noble_sword"],
		]);

		this.getAgent().m.EngageTargetMultipleOpponentsMult = 1.0;	// Vanilla: 1.25
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

		local r = ::Math.rand(1, 100);
		if (r <= 50)
		{
			local weapon = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/named/named_sword"],
			]).roll();
			this.getItems().equip(::new(weapon));
		}
		else if (r <= 75)	// named armor
		{
			local armor = ::Reforged.ItemTable.NamedArmorNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local stam = ::ItemTables.ItemInfoByScript[_script].StaminaModifier;
					if (stam < -16) return 0.0;
					return _weight;
				}
			});
			if (armor != null) this.getItems().equip(::new(armor));
		}
		else	// named helmet
		{
			local helmet = ::Reforged.ItemTable.NamedHelmetNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local stam = ::ItemTables.ItemInfoByScript[_script].StaminaModifier;
					if (stam < -8) return 0.0;
					return _weight;
				}
			});
			if (helmet != null) this.getItems().equip(::new(helmet));
		}

		this.getBaseProperties().ActionPoints += 1;

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
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_militia");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Swordmaster);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_parry"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_calculated_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_flow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_footwork"));
		this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_sword"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tempo"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_finesse"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_swordmaster_blade_dancer"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
