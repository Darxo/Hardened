this.hd_disrupted_flow_effect <- this.inherit("scripts/skills/skill", {
	m = {
		// Public
		InitiativePctPerStack = 0.15,	// This character loses this much initiative % (multiplier) per stack
		MaximumStacks = 6,		// This can be used to now confuse the player when otherwise the stacks keep increasing but not the debuff

		// Private
		Stacks = 1,
		MinimumInitiativeMult = 0.1,	// This makes sure that InitiativeMult never reaches 0.0, which would cause a division by 0 crash
	},

	function create()
	{
		this.m.ID = "effects.hd_disrupted_flow";
		this.m.Name = "Disrupted Flow";
		this.m.Description = "Your focus is broken, disrupting your timing and reactions.";
		this.m.Icon = "skills/status_effect_62.png";	// Same icon as used by hangover_effect and event-only trained_effect
		this.m.IconMini = "hd_disrupted_flow_mini";
		this.m.Overlay = "hd_disrupted_flow_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsStacking = false;
	}

	function getName()
	{
		return this.m.Stacks == 1 ? this.m.Name : this.m.Name + " (x" + this.m.Stacks + ")";
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.getInitiativeMult() != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.getInitiativeMult()) + " [Initiative|Concept.Initiative]"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]"),
		});

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= this.getInitiativeMult();
	}

	function onRefresh()
	{
		this.m.Stacks = ::Math.min(this.m.Stacks + 1, this.m.MaximumStacks);
		this.getContainer().update();
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

// New Functions
	function getInitiativeMult()
	{
		return ::Math.maxf(this.m.MinimumInitiativeMult, 1.0 - this.m.Stacks * this.m.InitiativePctPerStack);
	}

});
