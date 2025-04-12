::Hardened.HooksMod.hook("scripts/skills/actives/serpent_hook_skill", function(q) {
	q.isUsable = @(__original) function()
	{
		local actor = this.getContainer().getActor();
		local oldIsRooted = actor.getCurrentProperties().IsRooted;
		actor.getCurrentProperties().IsRooted = false;	// We switcheroo this property, because Snakes are now allowed to use serpent hook even while rooted

		local ret = __original();

		actor.getCurrentProperties().IsRooted = oldIsRooted;

		return ret && !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions());	// Serpents can no longer grab enemies, while engaged in melee
	}

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local actor = this.getContainer().getActor();
		if (actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because this character is [engaged|Concept.ZoneOfControl] in melee"),
			});
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used while [engaged|Concept.ZoneOfControl] in melee"),
			});
		}

		return ret;
	}
});
