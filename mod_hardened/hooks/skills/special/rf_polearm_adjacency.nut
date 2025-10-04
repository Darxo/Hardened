::Hardened.HooksMod.hook("scripts/skills/special/rf_polearm_adjacency", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Long range melee attacks are harder to use in a crowded environment. Any melee attack with a maximum range of 2 or more tiles has its hit chance reduced for each adjacent character.";

		this.m.MeleeSkillModifierPerAlly = -5;	// In Reforged this is 0
		this.m.NumAlliesToIgnore = 2;	// In Reforged this is 0
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/hitchance.png")
			{
				entry.text = ::MSU.String.replace(entry.text, " with lower [Reach|Concept.Reach] than you", "");
				break;
			}
		}

		return ret;
	}

// Reforged Functions
	// Overwrite, because we simplify the code and remove the reach condition for enemies
	q.getModifierForSkill = @() function( _skill )
	{
		if (!this.isEnabledForSkill(_skill)) return 0;

		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 0;

		local adjacentAllies = 0;
		local adjacentEnemies = 0;
		foreach (tile in ::MSU.Tile.getNeighbors(actor.getTile()))
		{
			if (::Math.abs(actor.getTile().Level - tile.Level) > 1) continue;	// Target is too low or too high to matter for us
			if (!tile.IsOccupiedByActor) continue;

			local neighbor = tile.getEntity();
			if (neighbor.isAlliedWith(actor))
			{
				adjacentAllies++;
			}
			else
			{
				adjacentEnemies++;
			}
		}

		local meleeSkillModifier = 0;
		meleeSkillModifier += this.m.MeleeSkillModifierPerAlly * ::Math.max(0, adjacentAllies - this.m.NumAlliesToIgnore);
		meleeSkillModifier += this.m.MeleeSkillModifierPerEnemy * ::Math.max(0, adjacentEnemies - this.m.NumEnemiesToIgnore);

		return meleeSkillModifier;
	}
});
