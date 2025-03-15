this.hd_whirling_death_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		ActionPointModifierOnRepeat = -2,
	},
	function create()
	{
		this.m.ID = "actives.hd_whirling_death";
		this.m.Name = "Whirling Death";
		this.m.Description = "Assume a relentless stance, swinging your flail in a deadly arc. Gain increased damage while keeping your enemies at bay.";
		this.m.Icon = "skills/hd_whirling_death_skill.png";
		this.m.IconDisabled = "skills/hd_whirling_death_skill_bw.png";
		this.m.Overlay = "hd_whirling_death_skill";
		this.m.SoundOnUse = [
			"sounds/combat/flail_01.wav",
			"sounds/combat/flail_02.wav",
			"sounds/combat/flail_03.wav",
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Offensive;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.HD_Defend_Stance;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		local whirlingDeathEffect = ::new("scripts/skills/effects/hd_whirling_death_effect");
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain the [Whirling Stance|Skill+hd_whirling_death_effect] effect"),
			children = whirlingDeathEffect.getTooltip().slice(2),	// Remove name and description tooltip lines
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Costs " + ::MSU.Text.colorizeValue(this.m.ActionPointModifierOnRepeat, {AddSign = true, InvertColor = true}) + " [Action Points|Concept.ActionPoints] while you have [Whirling Stance|Skill+hd_whirling_death_effect]"),
		});

		return ret;
	}

	function isUsable()
	{
		return !this.m.IsSpent && this.skill.isUsable();
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult *= _properties.IsSpecializedInFlails ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (this.getContainer().hasSkill("effects.hd_whirling_death"))
		{
			this.m.ActionPointCost += this.m.ActionPointModifierOnRepeat;
		}
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (!this.m.IsSpent)
		{
			this.m.IsSpent = true;

			this.getContainer().add(::new("scripts/skills/effects/hd_whirling_death_effect"));

			if (!_user.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " uses Whirling Death");
			}

			return true;
		}

		return false;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.hd_whirling_death");
	}
});

