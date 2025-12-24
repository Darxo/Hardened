::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_marksmanship", function(q) {
	// Public
	q.m.DamageModifier <- 10;
	q.m.RequiredIsolationDistance <- 3;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Free of nearby threats, your awareness sharpens.";
		this.m.IconMini = "perk_rf_marksmanship_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/damage_dealt.png",
			text = ::MSU.Text.colorizeValue(this.m.DamageModifier, {AddSign = true}) + " Damage",
		});

		return ret;
	}

	q.isHidden = @() function()
	{
		return !this.isEnabled();
	}

	// Overwrite because we scale the damage differently
	q.onUpdate = @() function(_properties)
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants damage depending on adjacent enemies
		if (this.isEnabled())
		{
			_properties.TargetAttractionMult *= 1.10;	// So that the AI will more often focus this character

			local bonus = this.getDamageBonus();
			_properties.DamageRegularMin += bonus;
			_properties.DamageRegularMax += bonus;
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return true;	// While on the world map, we want to display the damage bonus to the player

		local numAdjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), this.m.RequiredIsolationDistance).len();
		return (numAdjacentEnemies == 0);
	}

	q.getDamageBonus <- function()
	{
		return this.m.DamageModifier;
	}
});
