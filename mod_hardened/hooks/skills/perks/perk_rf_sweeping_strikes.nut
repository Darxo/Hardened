::Hardened.wipeClass("scripts/skills/perks/perk_rf_sweeping_strikes");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_sweeping_strikes", function(q) {
	// Config
	q.m.MeleeDefenseModifier <- 3;

	// Private
	q.m.CurrentMeleeDefenseModifier <- 0;

	q.create <- function()
	{
		this.m.ID = "perk.rf_sweeping_strikes";
		this.m.Name = ::Const.Strings.PerkName.RF_SweepingStrikes;
		this.m.Description = "This character is swinging his weapon in large sweeping motions, making it harder to approach him.";
		this.m.Icon = "ui/perks/perk_rf_sweeping_strikes.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.isHidden <- function()
	{
		return this.getCurrentMeleeDefenseModifier() == 0;
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		if (this.getCurrentMeleeDefenseModifier() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::MSU.Text.colorizeValue(this.getCurrentMeleeDefenseModifier(), {AddSign = true}) + " Melee Defense",
			});

			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Lasts until the start of your next turn",
			});
		}

		return ret;
	}

	q.onBeforeAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill.isAttack() && !_skill.isRanged() && _targetEntity != null)
		{
			local actor = this.getContainer().getActor();
			local adjacentHostiles = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true);
			this.m.CurrentMeleeDefenseModifier += adjacentHostiles.len() * this.m.MeleeDefenseModifier;
		}
	}

	q.onUpdate <- function( _properties )
	{
		_properties.MeleeDefense += this.getCurrentMeleeDefenseModifier();
	}

	q.onTurnStart <- function()
	{
		this.m.CurrentMeleeDefenseModifier = 0;
	}

	q.onCombatFinished <- function()
	{
		this.m.CurrentMeleeDefenseModifier = 0;
	}

// New Functions
	q.getCurrentMeleeDefenseModifier <- function()
	{
		return this.m.CurrentMeleeDefenseModifier;
	}
});
