::Hardened.wipeClass("scripts/skills/perks/perk_rf_combo", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_combo", function(q) {
	// Public
	q.m.ActionPointModifier <- -2;

	// Private
	q.m.UsedSkills <- {};	// Table of skill IDs and their skill name, that have been used this turn

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
					skill.m.ActionPointCost += this.m.ActionPointModifier;
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
		// This perk only counts skills you use during your turn
		// Otherwise, it would count allies using BreakFree on you, Shield Sergeants causing you to use shield skills or DefaultAttacks triggered by Riposte/Rebuke
		if (!this.getContainer().getActor().isActiveEntity()) return;

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
