::Hardened.HooksMod.hook("scripts/skills/special/rf_polearm_adjacency", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Long range melee attacks are harder to use in a crowded environment. Any melee attack with a maximum range of 2 or more tiles has its hit chance reduced for each adjacent character.";

		this.m.MalusPerAlly = 5;	// In Reforged this is 0
		this.m.NumAlliesToIgnore = 2;	// In Reforged this is 0
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.MalusPerAlly != 0)
		{
			local allyTooltipLine = {
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(-this.m.MalusPerAlly, {AddSign = true}) + " [Melee Skill|Concept.MeleeSkill] per ally"),
			};

			if (this.m.NumAlliesToIgnore != 0)
			{
				allyTooltipLine.children <- [{
					id = 1,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Ignore the first " + ::MSU.Text.colorizeValue(this.m.NumAlliesToIgnore) + " adjacent allies",
				}];
			}

			ret.push(allyTooltipLine);
		}

		if (this.m.MalusPerEnemy != 0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(-this.m.MalusPerEnemy, {AddSign = true}) + " [Melee Skill|Concept.MeleeSkill] per enemy"),
			});
		}

		return ret;
	}
});
