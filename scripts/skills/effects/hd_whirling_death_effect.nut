this.hd_whirling_death_effect <- this.inherit("scripts/skills/skill", {
	m = {
		// Public
		DamageMult = 1.3,
		ReachModifier = 2,
		MeleeDefenseModifier = 10,
		DurationInTurns = 2,

		// Private
		TurnsLeft = 2,	// so that nested tooltips has something to display
	},

	function create()
	{
		this.m.ID = "effects.hd_whirling_death";
		this.m.Name = "Whirling Stance";
		this.m.Description = "You are now in a relentless stance, your flail spinning in a deadly arc. Your attacks are more powerful while you keep your enemies at bay."
		this.m.Icon = "skills/hd_whirling_death_effect.png";
		this.m.IconMini = "hd_whirling_death_effect_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.DamageMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "Deal " + ::MSU.Text.colorizeMultWithText(this.m.DamageMult) + " damage",
			});
		}

		if (this.m.ReachModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/rf_reach.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.ReachModifier, {AddSign = true}) + " [Reach|Concept.Reach]"),
			});
		}

		if (this.m.MeleeDefenseModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.MeleeDefenseModifier, {AddSign = true}) + " [Melee Defense|Concept.MeleeDefense]"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts for " + ::MSU.Text.colorPositive(this.m.TurnsLeft) + " [turn(s)|Concept.Turn]"),
		});

		return ret;
	}

	function onAdded()
	{
		this.m.TurnsLeft = this.m.DurationInTurns;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.m.DurationInTurns;
	}

	function onUpdate( _properties )
	{
		if (!this.isValid())
		{
			this.removeSelf();
			return;
		}

		_properties.DamageTotalMult *= this.m.DamageMult;
		_properties.Reach += this.m.ReachModifier;
		_properties.MeleeDefense += this.m.MeleeDefenseModifier;
	}

	function onTurnEnd()
	{
		--this.m.TurnsLeft;

		if (this.m.TurnsLeft == 0)
		{
			this.removeSelf();
		}
	}

// New Functions
	function isValid()
	{
		if (this.getContainer().getActor().isDisarmed())
		{
			return false;
		}

		return true;
	}
});

