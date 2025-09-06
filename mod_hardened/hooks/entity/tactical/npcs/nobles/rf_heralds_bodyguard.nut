// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_heralds_bodyguard", function(q) {
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
	}
});
