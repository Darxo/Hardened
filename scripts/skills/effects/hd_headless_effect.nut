this.hd_headless_effect <- ::inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "effects.hd_headless";
		this.m.Name = "Headless";
		this.m.Description = "This character has no head.";
		this.m.Icon = "skills/hd_headless_effect.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
	}

	function onUpdate( _properties )
	{
		_properties.HeadshotReceivedChanceMult = 0.0;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, superCurrent )
	{
		if (_skill != null)
		{
			// MSU will reset these values back
			_skill.m.ChanceDecapitate = 0;
			_skill.m.ChanceSmash = 0;
		}

		// For safety we include this still. Some damage sources might want to force the head as the target
		_hitInfo.BodyPart = ::Const.BodyPart.Body;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();

		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = "Incoming attack will never hit the head",
		});

		return tooltip;
	}
});
