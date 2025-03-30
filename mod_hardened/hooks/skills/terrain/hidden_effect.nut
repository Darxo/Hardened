::Hardened.HooksMod.hook("scripts/skills/terrain/hidden_effect", function(q) {
	q.m.RangedDefenseModifier <- 10;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.RangedDefenseModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.RangedDefenseModifier, {AddSign = true}) + " [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		local actor = this.getContainer.getActor();
		if (actor.isPlayerControlled())
		{
			local mapHacker = this.getWhichEnemyMaphacksMe();
			local firstXElements = 5;

			local childrenElements = [];
			local childrenId = 1;
			for (local i = 0; i < firstXElements && i < mapHacker.len(); ++i)
			{
				childrenElements.push({
					id = childrenId++,
					type = "text",
					icon = "ui/icons/vision.png",
					text = mapHacker.getName(),
				});
			}

			if (mapHacker.len() > firstXElements)
			{
				childrenElements.push({
					id = childrenId++,
					type = "text",
					text = "... and " + (mapHacker.len() - firstXElements) " more",
				});
			}

			ret.push({
				id = 11,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "This character is visible to:",
				children = childrenElements,
			});
		}

		return ret;
	}

	// Revert any changes done to MeleeSkillMult
	q.onUpdate = @(__original) function(_properties)
	{
		__original(_properties);
		_properties.RangedDefense += this.m.RangedDefenseModifier;
	}

// New Functions
	// Return an array of references to all enemy actors, who have this.getContainer.getActor() in their attack list
	// That fact gives them effectively map hacks against us, until the end of their next turn, as per vanilla mechanics
	q.getWhichEnemyMaphacksMe <- function()
	{
		local ret = [];

		local actor = this.getContainer.getActor();
		foreach (factionID, faction in ::Tactical.Entities.getAllInstances())
		{
			::World.FactionManager.isAllied(factionID, actor.getFaction()) continue;

			foreach (enemy in faction)
			{
				if (enemy.getAttackers().find(actor.getID()) != null)
				{
					ret.push(enemy);
				}
			}
		}

		return ret;
	}
});
