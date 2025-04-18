this.hd_headless_effect <- ::inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "effects.hd_headless";
		this.m.Name = "Headless";
		this.m.Description = "This character has no head.";
		this.m.Icon = "skills/hd_headless_effect.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
	}

	function onAdded()
	{
		// Zombies, which lose their head, will now lose zombie_bite and have it replaced with a hand_to_hand skill
		if (this.getContainer().hasSkill("actives.zombie_bite"))
		{
			this.getContainer().removeByID("actives.zombie_bite");
			this.getContainer().add(::new("scripts/skills/actives/hd_zombie_punch_skill"));
		}
	}

	function onUpdate( _properties )
	{
		_properties.HeadshotReceivedChanceMult = 0.0;
		_properties.ArmorMult[1] *= 0.0;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, superCurrent )
	{
		if (_skill != null)
		{
			// MSU will reset these values back
			_skill.m.ChanceDecapitate = 0;
			_skill.m.ChanceSmash = 0;
		}

		// Some damage sources might want to force the head as the target (e.g. split man)
		if (_hitInfo.BodyPart == ::Const.BodyPart.Head)
		{
			// Ideally we'd void those damage sources but that is not possible this late
			// Instead we try to make them do nothing, by turning the damage to 0
			_hitInfo.DamageRegular = 0;
			_hitInfo.DamageArmor = 0;
		}
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();

		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = "Incoming attack will never target the head",
		});

		tooltip.push({
			id = 11,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = "Lose no hitpoints from damage sources targeting the head",
		});

		tooltip.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immunne to [Distracted|Skill+distracted_effect]"),
		});

		tooltip.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immunne to [Sleeping|Skill+sleeping_effect]"),
		});

		return tooltip;
	}
});
