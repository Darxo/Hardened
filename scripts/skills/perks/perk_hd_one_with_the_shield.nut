this.perk_hd_one_with_the_shield <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		ThresholdToReceiveInjuryMult = 1.0,
		HeadHitpointReceivedMult = 0.6,
		BodyHitpointReceivedMult = 0.6,
	},
	function create()
	{
		this.m.ID = "perk.hd_one_with_the_shield";
		this.m.Name = ::Const.Strings.PerkName.HD_OneWithTheShield;
		this.m.Description = "Shift your shield to guard vital points; raised to protect your head, lowered to shield your body";
		this.m.Icon = "ui/perks/perk_02.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;		// We need to apply our effect after other effects, like headless, apply their bodypart redirecting effects
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.ThresholdToReceiveInjuryMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("You have " + ::MSU.Text.colorizeMultWithText(this.m.ThresholdToReceiveInjuryMult) + " [Injury Threshold|Concept.InjuryThreshold]"),
			});
		}

		local headHitpointMult = this.getHeadHitpointMult();
		if (headHitpointMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "You take " + ::MSU.Text.colorizeMultWithText(headHitpointMult, {InvertColor = true}) + " Hitpoint Damage from Attacks to the Head",
			});
		}

		local bodyHitpointMult = this.getBodyHitpointMult();
		if (bodyHitpointMult != 1.0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "You take " + ::MSU.Text.colorizeMultWithText(bodyHitpointMult, {InvertColor = true}) + " Hitpoint Damage from Attacks to the Body",
			});
		}

		return ret;
	}

	function isHidden()
	{
		return this.skill.isHidden() || !this.isEnabled();
	}

	function onUpdate( _properties )
	{
		if (this.isEnabled())
		{
			_properties.ThresholdToReceiveInjuryMult *= this.m.ThresholdToReceiveInjuryMult;
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (!this.isEnabled()) return;
		if (_skill == null || !this.isSkillValid(_skill)) return;

		if (_hitInfo.BodyPart == ::Const.BodyPart.Head)
		{
			_properties.DamageReceivedRegularMult *= this.getHeadHitpointMult();
		}
		else
		{
			_properties.DamageReceivedRegularMult *= this.getBodyHitpointMult();
		}
	}

// Modular Vanilla Functions
	function getQueryTargetValueMult( _user, _target, _skill )
	{
		local ret = 1.0;

		if (_target.getID() == this.getContainer().getActor().getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			if (_skill == null) return ret;
			if (_skill.getID() == "actives.split_shield" || _skill.getID() == "actives.throw_spear")
			{
				ret *= 1.5;	// _user should try asap to destroy the shield against someone with "One with the Shield"
			}
		}

		return ret;
	}

// New Functions
	function isEnabled()
	{
		return this.getContainer().getActor().isArmedWithShield();
	}

	function isSkillValid( _skill )
	{
		return _skill.isAttack();
	}

	function getBodyHitpointMult()
	{
		foreach (skill in this.getContainer().m.Skills)
		{
			if (skill.getID() == "effects.shieldwall")
			{
				return 1.0;	// The presence of shieldwall means, this effect is NOT active
			}
		}

		return this.m.BodyHitpointReceivedMult;
	}

	function getHeadHitpointMult()
	{
		foreach (skill in this.getContainer().m.Skills)
		{
			if (skill.getID() == "effects.shieldwall")
			{
				return this.m.HeadHitpointReceivedMult;
			}
		}

		return 1.0;
	}
});
