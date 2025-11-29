this.hd_rebuke_effect <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		DamageTotalMult = 0.75,	// Damage multiplier while rebuke is active

		// Private
		ParentPerk = null,		// This perk requires an reference of perk_rf_rebuke so that I can reuse it's checks. Either a weakref or a full ref is fine
	},

	function create()
	{
		this.m.ID = "effects.hd_rebuke";
		this.m.Name = "Rebuke";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("This character will counter any missed melee attacks with a free melee attack. Requires a usable [Attack of Opportunity.|Concept.ZoneOfControl] Does not work while [stunned|Skill+stunned_effect] or [fleeing.|Concept.Morale]");
		this.m.Icon = "ui/perks/perk_rf_rebuke.png";
		this.m.IconMini = "perk_rf_rebuke_mini";
		this.m.Overlay = "perk_rf_rebuke";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.DamageTotalMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = ::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " Damage",
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

	function onMissed( _attacker, _skill )
	{
		if (!::MSU.isNull(this.m.ParentPerk) && this.m.ParentPerk.canProc(_attacker, _skill))
		{
			local info = {
				User = this.getContainer().getActor(),
				Skill = this.getContainer().getAttackOfOpportunity(), // we know it won't be null because we do a getAttackOfOpportunity check in canProc
				TargetTile = _attacker.getTile()
			};
			::Time.scheduleEvent(::TimeUnit.Virtual, ::Const.Combat.RiposteDelay, this.onRiposte.bindenv(this), info);
		}
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onUpdate( _properties )
	{
		if (::MSU.isNull(this.m.ParentPerk))
		{
			this.removeSelf();
		}
		else
		{
			_properties.DamageTotalMult *= this.m.DamageTotalMult;
		}
	}

// Modular Vanilla Functions
	function getQueryTargetValueMult( _user, _target, _skill )
	{
		local ret = 1.0;

		if (_target.getID() == this.getContainer().getActor().getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			if (_skill != null && !::MSU.isNull(this.m.ParentPerk) && this.m.ParentPerk.canProc(_user, _skill))
			{
				// It is not a good idea to attack into an active rebuke, it will turn off anyways, if we wait a turn
				// Right now we don't check whether our weapon would outrange the target or whether they can even see us
				ret *= 0.5;
			}
		}

		return ret;
	}

// New Functions
	function onRiposte( _info )	// async function
	{
		if (!_info.User.isAlive()) return;
		if (_info.User.m.RiposteSkillCounter == ::Const.SkillCounter) return;	// This is a shared variable used by all riposte effects and ensures that no two riposte effects can trigger from the same attack

		// Check whether our ZOC skill is valid. We can't use isUsableOn because that function checks for skill cost too, which we do not want
		if (!_info.User.getTile().hasLineOfSightTo(_info.TargetTile, _info.User.getCurrentProperties().getVision())) return;
		if (!_info.Skill.verifyTargetAndRange(_info.TargetTile, _info.User.getTile())) return;

		_info.User.m.RiposteSkillCounter = ::Const.SkillCounter;
		_info.Skill.useForFree(_info.TargetTile);
	}
});
