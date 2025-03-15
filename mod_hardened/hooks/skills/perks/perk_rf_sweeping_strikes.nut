::Hardened.wipeClass("scripts/skills/perks/perk_rf_sweeping_strikes", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_sweeping_strikes", function(q) {
	// Config
	q.m.MeleeDefenseModifier <- 5;
	q.m.RequiredItemType <- ::Const.Items.ItemType.TwoHanded;	// If this is null, then we dont care about the weapon or wether any weapon is equipped

	// Private
	q.m.CurrentMeleeDefenseModifier <- 0;

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
				text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
			});
		}

		return ret;
	}

	q.onBeforeAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.CurrentMeleeDefenseModifier == 0 && this.isSkillValid(_skill))
		{
			local actor = this.getContainer().getActor();
			if (actor.getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				local adjacentHostiles = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true);
				this.m.CurrentMeleeDefenseModifier += adjacentHostiles.len() * this.m.MeleeDefenseModifier;
			}
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

// Hardened Functions
	// If we are evaluating _target, potentially targeting them with _usedSkill, how would that change the targets perceived value?
	q.getQueryTargetMultAsUser = @(__original) function( _target, _usedSkill = null )	// Const
	{
		local ret = __original(_target, _usedSkill);
		if (_usedSkill == null) return ret;
		if (this.getCurrentMeleeDefenseModifier() != 0) return ret;	// We already triggered this skill once this turn and cannot do it again

		if (this.isSkillValid(_usedSkill))
		{
			local actor = this.getContainer().getActor();

			// Every adjacent hostile characters makes it more attractive to use an attack boosting my melee defense
			ret *= 1 + (0.1 * ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true).len());
		}

		return ret;
	}

// New Functions
	q.getCurrentMeleeDefenseModifier <- function()
	{
		return this.m.CurrentMeleeDefenseModifier;
	}

	q.isSkillValid <- function( _skill )
	{
		if (_skill.isRanged()) return false;
		if (!_skill.isAttack()) return false;

		if (this.m.RequiredItemType == null) return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isItemType(this.m.RequiredItemType);
	}
});
