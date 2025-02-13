::Hardened.wipeClass("scripts/skills/perks/perk_rf_combo");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_combo", function(q) {
	// Public
	q.m.ActionPointModifier <- -1;

	// Private
	q.m.UsedSkills <- {};	// Table of skill IDs and their skill name, that have been used this turn

	q.create <- function()
	{
		this.m.ID = "perk.rf_combo";
		this.m.Name = ::Const.Strings.PerkName.RF_Combo;
		this.m.Description = "The good old one-two!";
		this.m.Icon = "ui/perks/perk_rf_combo.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Any;
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		if (this.m.UsedSkills.len() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString(format("All skills that you have not used yet this [round,|Concept.Round] cost %s [Action Point|Concept.ActionPoints]", ::MSU.Text.colorizeValue(this.m.ActionPointModifier, {InvertColor = true, AddSign = true}))),
			});

			local childrenElements = [];
			local childrenId = 1;
			foreach (index, name in this.m.UsedSkills)
			{
				childrenElements.push({
					id = childrenId,
					type = "text",
					icon = "ui/icons/unlocked_small.png",
					text = name,
				});
				++childrenId;
			}

			ret.push({
				id = 11,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Skills used already:",
				children = childrenElements,
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return this.m.UsedSkills.len() == 0;
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (this.m.UsedSkills.len() != 0)	// We only apply the discount after at least one skill has already been used
		{
			// Apply the Action Point Discount
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + this.m.ActionPointModifier);
				}
			}
		}
	}

	q.onNewRound <- function()
	{
		this.m.UsedSkills.clear();
	}

	q.onCombatFinished <- function()
	{
		this.m.UsedSkills.clear();
	}

// Hardened Events
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		if (!(_skill.getID() in this.m.UsedSkills))
		{
			this.m.UsedSkills[_skill.getID()] <- _skill.getName();
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill.getID() in this.m.UsedSkills)
		{
			return false;
		}

		return true;
	}
});
