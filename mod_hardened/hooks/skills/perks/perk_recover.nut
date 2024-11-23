::Hardened.wipeClass("scripts/skills/perks/perk_recover");

// This unused Vanilla perk is hijacked an renamed into "One with the Shield"
::Hardened.HooksMod.hook("scripts/skills/perks/perk_recover", function(q) {
	// Public
	q.m.ThresholdToReceiveInjuryMult <- 1.25;
	q.m.HeadHitpointReceivedMult <- 0.6;
	q.m.BodyHitpointReceivedMult <- 0.6;

	q.create <- function()
	{
		this.m.ID = "perk.recover";
		this.m.Name = ::Const.Strings.PerkName.Recover;
		this.m.Description = "Shift your shield to guard vital points; raised to protect your head, lowered to shield your body";
		this.m.Icon = "ui/perks/perk_02.png";
		this.m.IconMini = "";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;		// We need to apply our effect after other effects, like headless, apply their bodypart redirecting effects
	}

	q.isHidden <- function()
	{
		return this.skill.isHidden() || !this.isEnabled();
	}

	q.getTooltip <- function()
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
				text = "You have " + ::MSU.Text.colorizeMultWithText(headHitpointMult, {InvertColor = true}) + " Hitpoint Damage from Attacks to the Head",
			});
		}

		local bodyHitpointMult = this.getBodyHitpointMult();
		if (bodyHitpointMult != 1.0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "You have " + ::MSU.Text.colorizeMultWithText(bodyHitpointMult, {InvertColor = true}) + " Hitpoint Damage from Attacks to the Body",
			});
		}

		return ret;
	}

	q.onUpdate <- function( _properties )
	{
		if (this.isEnabled())
		{
			_properties.ThresholdToReceiveInjuryMult *= this.m.ThresholdToReceiveInjuryMult;
		}
	}

	q.onBeforeDamageReceived <- function( _attacker, _skill, _hitInfo, _properties )
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

// New Functions
	q.isEnabled <- function()
	{
		return this.getContainer().getActor().isArmedWithShield();
	}

	q.isSkillValid <- function( _skill )
	{
		return _skill.isAttack();
	}

	q.getBodyHitpointMult <- function()
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

	q.getHeadHitpointMult <- function()
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
