::Hardened.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_queryUIElementTooltipData = @(__original) function( _entityId, _elementId, _elementOwner )
	{
		local entity = (_entityId == null) ? null : ::Tactical.getEntityByID(_entityId);

		local ret = __original(_entityId, _elementId, _elementOwner);
		if (entity == null) return ret;

		if (_elementId == "character-stats.MeleeSkill")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "/ui/icons/melee_skill.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().MeleeSkill)
				},
				{

					id = 4,
					type = "text",
					icon = "/ui/icons/melee_skill.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getCurrentProperties().getMeleeSkill() - entity.getBaseProperties().MeleeSkill)
				}/*,
				{

					id = 5,
					type = "text",
					icon = "/ui/icons/melee_skill.png",
					text = "Multiplier: " + entity.getBaseProperties().MeleeSkillMult
				}*/
			]);
		}

		else if (_elementId == "character-stats.RangeSkill")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "/ui/icons/ranged_skill.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().RangedSkill)
				},
				{
					id = 4,
					type = "text",
					icon = "/ui/icons/ranged_skill.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getCurrentProperties().getRangedSkill() - entity.getBaseProperties().RangedSkill)
				}
			]);
		}

		if (_elementId == "character-stats.MeleeDefense")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "/ui/icons/melee_defense.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().MeleeDefense)
				},
				{

					id = 4,
					type = "text",
					icon = "/ui/icons/melee_defense.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getCurrentProperties().getMeleeDefense() - entity.getBaseProperties().MeleeDefense)
				}
			]);
		}

		else if (_elementId == "character-stats.RangeDefense")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "/ui/icons/ranged_defense.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().RangedDefense)
				},
				{

					id = 4,
					type = "text",
					icon = "/ui/icons/ranged_defense.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getCurrentProperties().getRangedDefense() - entity.getBaseProperties().RangedDefense)
				}
			]);
		}

		else if (_elementId == "character-stats.Hitpoints")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "ui/icons/health.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().Hitpoints)
				},
				{

					id = 4,
					type = "text",
					icon = "ui/icons/health.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getHitpointsMax() - entity.getBaseProperties().Hitpoints)
				}
			]);
		}

		else if (_elementId == "character-stats.Fatigue")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().Stamina)
				},
				{

					id = 4,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getFatigueMax() - entity.getBaseProperties().Stamina)
				},
				{

					id = 8,
					type = "text",
					icon = "ui/icons/fatigue.png",
					text = "Fatigue Recovery: " + ::MSU.Text.colorizeValue(entity.getCurrentProperties().FatigueRecoveryRate)
				},
				{

					id = 6,
					type = "text",
					icon = "ui/icons/bag.png",
					text = "Total Weight: " + ::Math.abs(entity.getItems().getWeight())
				}
			]);
		}

		else if (_elementId == "character-stats.Initiative")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().Initiative)
				},
				{

					id = 4,
					type = "text",
					icon = "ui/icons/initiative.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getInitiative() - entity.getBaseProperties().Initiative)
				}
			]);
		}

		else if (_elementId == "character-stats.Bravery")
		{
			ret.extend([
				{

					id = 3,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "Base: " + ::MSU.Text.colorizeValue(entity.getBaseProperties().Bravery)
				},
				{

					id = 4,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "Modifier: " + ::MSU.Text.colorizeValue(entity.getCurrentProperties().getBravery() - entity.getBaseProperties().Bravery)
				}
			]);
		}

		return ret;
	}
});

