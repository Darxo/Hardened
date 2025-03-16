::Hardened.wipeClass("scripts/skills/perks/perk_rf_the_rush_of_battle", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_the_rush_of_battle", function(q) {
	// Public
	q.m.InjuryThresholdPctPerEnemy <- 0.2;	// We gain this much more InjuryThreshold against incoming attacks for each adjacent enemy
	q.m.FatigueCostPctPerAlly <- 0.1;		// Skills cost this much less Fatigue for each adjacent ally

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		local injuryThresholdMult = this.getInjuryThresholdMult();
		if (injuryThresholdMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/asset_medicine.png",	// This is not an ideal icon, but at least closely related
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(injuryThresholdMult) + " [Injury Threshold|Concept.InjuryThreshold]"),
			});
		}

		local fatigueMult = this.getFatigueMult();
		if (fatigueMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("Skills cost " + ::MSU.Text.colorizeMultWithText(fatigueMult, {InvertColor = true}) + " [Fatigue|Concept.Fatigue]"),
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return (this.getInjuryThresholdMult() == 1.0 && this.getFatigueMult() == 1.0);
	}

	q.onUpdate <- function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants its bonus depending on adjacent characters
		_properties.ThresholdToReceiveInjuryMult *= this.getInjuryThresholdMult();
	}

	q.onAfterUpdate <- function( _properties )
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return;

		local customOrigin = null;
		if (actor.isPreviewing() && actor.getPreviewMovement() != null)
		{
			// If we are previewing movement, we instead want the discount depending on the destination tile
			customOrigin = actor.getPreviewMovement().End;
		}

		local fatigueMult = this.getFatigueMult(customOrigin);
		if (fatigueMult != 1.0)
		{
			foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
			{
				skill.m.FatigueCostMult *= fatigueMult;
			}
		}
	}

// New Functions
	q.getInjuryThresholdMult <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 1.0;

		if (::Tactical.Entities.getAlliedActors(actor.getFaction(), actor.getTile(), 1, true).len() == 0)
		{
			return 1.0;		// This perk requires at least one adjacent ally, to grant Injury Threshold
		}

		local numAdjacentEnemies = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true).len();
		return 1.0 + (numAdjacentEnemies * this.m.InjuryThresholdPctPerEnemy);
	}

	q.getFatigueMult <- function( _customOrigin = null )
	{
		local actor = this.getContainer().getActor();
		if (_customOrigin == null)
		{
			if (actor.isPlacedOnMap())
			{
				_customOrigin = actor.getTile();
			}
			else
			{
				return 1.0;
			}
		}

		if (::Tactical.Entities.getHostileActors(actor.getFaction(), _customOrigin, 1, true).len() == 0)
		{
			return 1.0;		// This perk requires at least one adjacent enemy, to grant a Fatigue Discount
		}

		local numAdjacentAllies = ::Tactical.Entities.getAlliedActors(actor.getFaction(), _customOrigin, 1, true).len();
		return 1.0 - (numAdjacentAllies * this.m.FatigueCostPctPerAlly);
	}
});
