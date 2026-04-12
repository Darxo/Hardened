::Hardened.HooksMod.hook("scripts/skills/effects/rf_dodge_potion_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "Thanks to a draught prepared with the essence of spirits, shifting apparitions to trail you, making it difficulty for distant enemies to tell where your real body stands.";
	}

	// Overwrite, because we add a different effect for this potion
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [Ethereal|Perk+perk_hd_ethereal]"),
		});

		ret.push({
			id = 7,
			type = "hint",
			icon = "ui/icons/action_points.png",
			text = "Will be gone after 1 more battle",
		});

		return ret;
	}

	q.onAdded = @() function()
	{
		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_hd_ethereal", function(o) {
			o.m.IsSerialized = false;
		}));
	}

	q.onRemoved = @() function()
	{
		// We need to use "removeByStackByID" (added by Stack-Based-Skills), because its hook of the vanilla removeByID , used on perks, only remove the serialized version of them
		this.getContainer().removeByStackByID("perk.hd_ethereal", false);
	}
});
