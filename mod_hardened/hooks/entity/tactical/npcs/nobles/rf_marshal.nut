// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_marshal", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_military");
		this.getSprite("accessory_special").setBrush("rf_marshal_trophy");

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
		b.setValues(::Const.Tactical.Actor.RF_Marshal);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_steel_brow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_the_rush_of_battle"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_exude_confidence"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_parry"));

		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_blitzkrieg"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_decisive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rally_the_troops"));
	}
});
