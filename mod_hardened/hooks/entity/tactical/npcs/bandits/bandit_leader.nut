// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_leader", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Muscular;	// Reforged: ::Const.Bodies.AllMale
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greataxe"],
			[12, "scripts/items/weapons/bardiche"],
			[12, "scripts/items/weapons/winged_mace"],
			[12, "scripts/items/weapons/warhammer"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/heater_shield"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() function()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
	}}.assignRandomEquipment;

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_bandits");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = this.Math.rand(150, 255);
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.BanditLeader);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));

		this.getSkills().add(::Reforged.new("scripts/skills/perks/perk_rally_the_troops", function(o) {
			o.m.ActionPointCost = 3;
		}));

		this.getSkills().add(::new("scripts/skills/perks/perk_inspiring_presence"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor = ::Reforged.ItemTable.BanditArmorLeader.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax < 210 || conditionMax > 240) return 0.0;
					return _weight;
				}
			})
			if (armor != null) this.getItems().equip(::new(armor))
		}

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			local helmet = ::Reforged.ItemTable.BanditHelmetLeader.roll({
				Apply = function ( _script, _weight )
				{
					local conditionMax = ::ItemTables.ItemInfoByScript[_script].ConditionMax;
					if (conditionMax < 180 || conditionMax > 230) return 0.0;
					return _weight;
				}
			})
			if (helmet != null) this.getItems().equip(::new(helmet));
		}
	}
});
