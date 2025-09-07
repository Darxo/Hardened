// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_fencer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/fencing_sword"],
			[12, "scripts/items/weapons/rf_estoc"],
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
				[12, "scripts/items/weapons/named/named_fencing_sword"],
				[12, "scripts/items/weapons/named/named_rf_estoc"],
			]).roll();
			this.getItems().equip(::new(weapon));
		}
		else if (r == 2)
		{
			local armor = ::Reforged.ItemTable.NamedArmorNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if ( conditionMax > 165) return 0.0;
					return _weight;
				}
			})
			this.getItems().equip(::new(armor));
		}
		else if (r == 3)
		{
			local helmet = ::Reforged.ItemTable.NamedHelmetNorthern.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax > 145) return 0.0;
					return _weight;
				}
			})
			this.getItems().equip(::new(helmet));
		}

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_finesse"));
		return true;
	}}.makeMiniboss;

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
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isItemType(::Const.Items.ItemType.OneHanded))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));
			}
			else
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
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
		b.setValues(::Const.Tactical.Actor.RF_Fencer);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_sword"));
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_relentless"));
		this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_the_rush_of_battle"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_fencer"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tempo"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.m.IsMiniboss)
		{
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
			{
				this.getItems().equip(::new("scripts/items/armor/noble_mail_armor"));
			}

			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
			{
				this.getItems().equip(::new("scripts/items/helmets/greatsword_hat"));
			}
		}
		else
		{
			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
			{
				this.getItems().equip(::new(::MSU.Class.WeightedContainer([
					[1, "scripts/items/armor/basic_mail_shirt"],
					[1, "scripts/items/armor/mail_shirt"],
					[1, "scripts/items/armor/leather_scale_armor"],
				]).roll()));
			}

			if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head) && ::Math.rand(1, 100) > 20)
			{
				this.getItems().equip(::new(::MSU.Class.WeightedContainer([
					[1, "scripts/items/helmets/headscarf"],
					[1, "scripts/items/helmets/aketon_cap"],
					[1, "scripts/items/helmets/full_aketon_cap"],
					[1, "scripts/items/helmets/greatsword_hat"],
				]).roll()));
			}
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
