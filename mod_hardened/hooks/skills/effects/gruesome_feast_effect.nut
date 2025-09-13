::Hardened.HooksMod.hook("scripts/skills/effects/gruesome_feast_effect", function(q) {
	q.onUpdate = @() function( _properties )
	{
		local size = this.getContainer().getActor().getSize();
		if (size == 3)
		{
			this.getContainer().getActor().getAIAgent().getProperties().BehaviorMult[::Const.AI.Behavior.ID.Retreat] = 0.0;
		}
	}

	// Overwrite, because almost all vanilla effects have moved out of this effect
	q.getTooltip = @() { function getTooltip()
		{
			local ret = this.skill.getTooltip();

			local size = this.getContainer().getActor().getSize();
			if (size == 2)
			{
			}
			else if (size == 3)
			{
				ret.push({
					id = 15,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("Will never retreat the battle"),
				});
			}

			return ret;
		}}.getTooltip;
});
