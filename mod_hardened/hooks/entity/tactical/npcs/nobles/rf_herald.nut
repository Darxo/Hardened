// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/rf_herald", function(q) {
	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		// Switcheroo of addSprite so that we add our custom surcoat directly after the vanilla one
		local addSprite = this.addSprite;
		this.addSprite = function( _sprite )
		{
			if (_sprite == "surcoat")
			{
				local ret = addSprite(_sprite);
				addSprite("rf_surcoat_adornment"); // TODO: Once item layers are available then this won't be necessary and the onFactionChanged and onDeath functions can be removed
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
		b.setValues(::Const.Tactical.Actor.RF_Herald);
		b.TargetAttractionMult = 1.5;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_inspiring_presence"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rally_the_troops"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_hold_steady"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_polearm"));
	}
});
