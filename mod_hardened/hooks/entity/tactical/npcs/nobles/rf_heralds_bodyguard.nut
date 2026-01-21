// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_heralds_bodyguard", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/rf_brigandine_harness"],
			[12, "scripts/items/armor/rf_reinforced_footman_armor"],
			[12, "scripts/items/armor/scale_armor"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/warbrand"],
			[12, "scripts/items/weapons/rf_swordstaff"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		// Switcheroo of addSprite so that we add our custom rf_helmet_adornment directly after the vanilla helmet_damage
		local addSprite = this.addSprite;
		this.addSprite = function( _sprite )
		{
			if (_sprite == "helmet_damage")
			{
				local ret = addSprite(_sprite);
				addSprite("rf_helmet_adornment"); // TODO: Once item layers are available then this won't be necessary and the onFactionChanged, onDeath, onDamageReceived functions can be removed
				return ret;
			}
			return addSprite(_sprite);
		}
		this.human.onInit();
		this.addSprite = addSprite;

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

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
		b.setValues(::Const.Tactical.Actor.RF_HeraldsBodyguard);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/special/rf_bodyguard"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_relentless"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_sword"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigilant"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_pattern_recognition"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_combo"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_swordmaster_grappler"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		local banner = ::Tactical.State.isScenarioMode() ? this.getFaction() : ::World.FactionManager.getFaction(this.getFaction()).getBanner();
		this.getBodyItem().setUpgrade(::Reforged.new("scripts/items/armor_upgrades/rf_heraldic_cape_upgrade", function(o) {
			o.setVariant(banner);
		}));

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			local helmet = ::new(::MSU.Class.WeightedContainer([
				[1, "scripts/items/helmets/rf_sallet_helmet_with_bevor"],
				[1, "scripts/items/helmets/rf_half_closed_sallet_with_mail"],
				[1, "scripts/items/helmets/full_helm"],
			]).roll());

			helmet.setPlainVariant();
			this.getItems().equip(helmet);

			if (helmet.ClassName == "full_helm")
				this.setSpriteOffset("rf_helmet_adornment", ::createVec(0, 5));
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

		this.m.HelmetAdornment.Sprite = "faction_helmet_2_" + (banner < 10 ? "0" + banner : banner);
		this.m.HelmetAdornment.SpriteDamaged = this.m.HelmetAdornment.Sprite + "_damaged";
		this.m.HelmetAdornment.SpriteDead = this.m.HelmetAdornment.Sprite + "_dead";
		this.getSprite("rf_helmet_adornment").setBrush(this.m.HelmetAdornment.Sprite);
	}
});
