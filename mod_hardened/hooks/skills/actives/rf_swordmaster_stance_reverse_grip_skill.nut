::Hardened.HooksMod.hook("scripts/skills/actives/rf_swordmaster_stance_reverse_grip_skill", function(q) {
	// Public
	q.m.HD_ReachModifier <- -1;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/rf_reach.png")
			{
				entry.icon = "ui/icons/special.png";	// Reforged uses the reach icon here
				// We completely rework the Reforged perk Concussive Strikes, so we need to adjust its name here too
				entry.text = ::MSU.String.replace(entry.text, "Concussive Strikes", "Shockwave");
			}
			else if (entry.id == 12 && entry.icon == "ui/icons/rf_reach.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.HD_ReachModifier, {AddSign = true}) + " [Reach|Concept.Reach]");
			}
		}

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Your equipped Sword also qualifies as a Mace"),
		});

		return ret;
	}

	// Overwrite, because we replace the reforged reach effect
	q.onUpdate = @() function( _properties )
	{
		if (!this.m.IsOn) return;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon != null) _properties.Reach += this.m.HD_ReachModifier;
	}
});
