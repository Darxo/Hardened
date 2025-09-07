// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_killer", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Skinny;	// Reforged: ::Const.Bodies.AllMale
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/billhook"],
			[12, "scripts/items/weapons/rf_poleflail"],
			[24, "scripts/items/weapons/rondel_dagger"],
		]);

		// If the offhand is empty (spawned with dagger), we also equip a net
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/tools/reinforced_throwing_net"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() function()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		// This champion only ever spawns with named weapons, never with named gear
		if (::Math.rand(1, 2) == 1)
		{
			local namedMeleeWeapon = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/named/named_billhook"],
				[12, "scripts/items/weapons/named/named_rf_poleflail"],
				[24, "scripts/items/weapons/named/named_dagger"],
			]).roll();
			this.getItems().equip(::new(namedMeleeWeapon));
		}
		else
		{
			local namedThrowingWeapon = ::new(::MSU.Class.WeightedContainer([
				[12, "scripts/items/weapons/named/named_javelin"],
				[12, "scripts/items/weapons/named/named_throwing_axe"],
			]).roll());
			this.getItems().addToBag(namedThrowingWeapon);
		}

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_fresh_and_furious"));

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
			if (weapon.isWeaponType(::Const.Items.WeaponType.Polearm))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_long_reach"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_leverage"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Flail))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_flail"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_flail_spinner"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_between_the_ribs"));
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_dagger"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_swift_stabs"));
			}
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_bandits");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = ::Math.rand(150, 255);
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);

		local tattoo_head = this.getSprite("tattoo_head");
		tattoo_head.setBrush("warpaint_0" + ::Math.rand(2, 3) + "_head");
		tattoo_head.Visible = true;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_BanditKiller);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_ghostlike"));
		this.getSkills().add(::new("scripts/skills/perks/perk_relentless"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_hybridization"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor = ::Reforged.ItemTable.BanditArmorFast.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax <= 100 || conditionMax > 140) return 0.0;
					return _weight;
				}
			})

			if (armor != null) this.getItems().equip(::new(armor));
		}

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			local helmet = ::Reforged.ItemTable.BanditHelmetFast.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax <= 90 || conditionMax > 130) return 0.0;
					return _weight;
				}
			})
			this.getItems().equip(::new(helmet));
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local throwingWeapon = ::new("scripts/items/weapons/throwing_axe");
		throwingWeapon.m.Ammo = 3;
		this.getItems().addToBag(throwingWeapon);
	}
});
