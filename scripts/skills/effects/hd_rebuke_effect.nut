this.hd_rebuke_effect <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		DamageTotalMult = 0.75,	// Damage multiplier while rebuke is active
	},

	function create()
	{
		this.m.ID = "effects.hd_rebuke";
		this.m.Name = "Rebuke";
		this.m.Description = "Show \'em how it\'s done!";
		this.m.Icon = "ui/perks/perk_rf_rebuke.png";
		this.m.IconMini = "perk_rf_rebuke_mini";
		this.m.Overlay = "perk_rf_rebuke";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/stat_screen_dmg_dealt.png",	// Same Icon as Reach in Reforged
			text = ::Reforged.Mod.Tooltips.parseString("Trigger a free melee attack on any enemy who misses a melee attack against you"),
			children = [
				{
					id = 10,
					type = "text",
					text = ::Reforged.Mod.Tooltips.parseString("Requires a usable [Attack of Opportunity|Concept.ZoneOfControl]"),
				},
				{
					id = 11,
					type = "text",
					text = ::Reforged.Mod.Tooltips.parseString("Does not work while [stunned|Skill+stunned_effect] or [fleeing|Skill+hd_dummy_morale_state_fleeing]"),
				},
			],
		});

		if (this.m.DamageTotalMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "Deal " + ::MSU.Text.colorizeMultWithText(this.m.DamageTotalMult) + " Damage",
			});
		}

		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
		});

		return ret;
	}

	function onMissed( _attacker, _skill )
	{
		if (this.isSkillValid(_skill))
		{
			local info = {
				User = this.getContainer().getActor(),
				Skill = this,	// So that we can use functions working on this skills
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
		_properties.DamageTotalMult *= this.m.DamageTotalMult;
	}

// Modular Vanilla Functions
	function getQueryTargetValueMult( _user, _target, _skill )
	{
		local ret = 1.0;

		local actor = this.getContainer().getActor();
		if (_target.getID() == actor.getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			if (_skill != null && this.isSkillValid(_skill) && this.isEnabled() && this.canRiposteAgainst(_user.getTile()))
			{
				// It is not a good idea to attack into an active rebuke, it will turn off anyways, if we wait a turn
				ret *= 0.6;
			}
		}

		return ret;
	}

// New Functions
	function onRiposte( _info )	// async function
	{
		if (!_info.Skill.isEnabled()) return;
		if (!_info.Skill.canRiposteAgainst(_info.TargetTile)) return;

		_info.User.m.RiposteSkillCounter = ::Const.SkillCounter;
		_info.Skill.getContainer().getAttackOfOpportunity().useForFree(_info.TargetTile);
	}

	// Are we allowed to do counter attacks right now?
	function isEnabled()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive()) return false;
		if (actor.isActiveEntity()) return false;	// This perk only works while it is not our turn
		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing || actor.getCurrentProperties().IsStunned) return false;
		if (actor.m.RiposteSkillCounter == ::Const.SkillCounter) return false;	// This is a shared variable used by all riposte effects and ensures that no two riposte effects can trigger from the same attack

		return true;
	}

	// Are we allowed to do a riposte against _targetTile?
	function canRiposteAgainst( _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor) return false;

		local attackOfOpportunity = this.getContainer().getAttackOfOpportunity();
		if (attackOfOpportunity == null) return false;

		local actor = this.getContainer().getActor();
		if (!actor.getTile().hasLineOfSightTo(_targetTile, actor.getCurrentProperties().getVision())) return false;
		if (!attackOfOpportunity.verifyTargetAndRange(_targetTile)) return false;

		return true;
	}

	// Is the attacking skill valid to trigger a riposte?
	function isSkillValid( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged() && !_skill.isIgnoringRiposte();
	}
});
