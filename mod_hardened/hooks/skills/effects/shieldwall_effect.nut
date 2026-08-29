::Hardened.HooksMod.hook("scripts/skills/effects/shieldwall_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Name = "Shieldwalling";		// Vanilla: Shieldwall
	}

	q.getTooltip = @(__original) function()
	{
		if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			// We generate a general tooltip for when the user is the dummy player and there usually is no shield available to make the vanilla one work
			local ret = this.skill.getTooltip();

			ret.extend([
				{
					id = 10,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = ::MSU.Text.colorizeMultWithText(2.0) + ::Reforged.Mod.Tooltips.parseString(" [$ $|Concept.MeleeDefense] from equipped shield"),
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = ::MSU.Text.colorizeMultWithText(2.0) + ::Reforged.Mod.Tooltips.parseString(" [$ $|Concept.RangeDefense] from equipped shield"),
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Gain " + ::MSU.Text.colorPositive("+5")+ ::Reforged.Mod.Tooltips.parseString(" [$ $|Concept.MeleeDefense] and [$ $|Concept.RangeDefense] for each adjacent ally from your faction with [$ $|Skill+shieldwall_effect]"),
				},
			]);

			return ret;
		}
		else
		{
			return __original();
		}
	}

	q.onUpdate = @(__original) function( _properties )
	{
		// In Vanilla shieldwall_effect will be removed, whenever shieldwall (skill) is removed. But in Hardened someone without shieldwall (skill) can gain that effect
		// This effect would not be removed when they switch away from the shield, causing glitches. So now we implement a check, that vanilla should have implemented themselves
		local item = this.getContainer().getActor().getOffhandItem();
		if (item == null || !item.isItemType(::Const.Items.ItemType.Shield))
		{
			this.removeSelf();
		}
		else
		{
			__original(_properties);
		}
	}
});
