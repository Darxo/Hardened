::Hardened.wipeClass("scripts/skills/perks/perk_rf_feral_rage", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_feral_rage", function(q) {
	// Public
	q.m.HD_RageStacksMax <- 4;
	q.m.HD_DamageTotalPctPerStack <- 0.25;

	q.m.HD_StackThreshold <- 4;		// When you have at least this many stacks, unlock a bonus effect
	q.m.HD_DamageReceivedRegularMult <- 0.8;	// Hitpoint Damage Mitigation from Attacks when meeting stack threshold

	// Private
	q.m.HD_RageStacks <- 0;		// This many additional bleed stacks are applied by this perk on an non-AoE attack

	q.create = @(__original) function()
	{
		__original();
		this.m.ID = "perk.rf_feral_rage";
		this.m.Description = "You are consumed by uncontrollable rage.";
	}

	q.getName = @(__original) function()
	{
		return this.m.HD_RageStacks == 0 ? __original() : __original() + " (x" + this.m.HD_RageStacks + ")";
	}

	q.isHidden = @() function()
	{
		return !this.isEnabled();
	}

	// Overwrite, because our
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		if (this.getDamageTotalMult() != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = ::Reforged.Mod.Tooltips.parseString("Deal " + ::MSU.Text.colorizeMultWithText(this.getDamageTotalMult()) + " Damage with Non-AoE Attacks"),
			});
		}

		if (this.getDamageReceivedRegularMult() != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = ::Reforged.Mod.Tooltips.parseString("Take " + ::MSU.Text.colorizeMultWithText(this.getDamageReceivedRegularMult(), {InvertColor = true}) + " [Hitpoint|Concept.Hitpoints] Damage"),
			});
		}

		if (this.isImmuneToStuns())
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("[Immune to Stun|Skill+stunned_effect]"),
			});
		}

		return ret;
	}

	q.onUpdate = @() function( _properties )
	{
		if (this.isEnabled()) _properties.ShowFrenzyEyes = true;

		if (this.isImmuneToStuns()) _properties.IsImmuneToStun = true;
		_properties.DamageReceivedRegularMult *= this.getDamageReceivedRegularMult();
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (this.isSkillValid(_skill))
		{
			_properties.DamageTotalMult *= this.getDamageTotalMult();
		}
	}

	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.HD_RageStacks == 0) return;
		if (!this.isSkillValid(_skill)) return;

		this.m.HD_RageStacks = 0;
		local actor = this.getContainer().getActor();
		::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Actor * 1.0, actor.getPos(), ::MSU.Math.randf(0.9, 1.1) * actor.getSoundPitch());
	}

	q.onTargetMissed = @() function( _skill, _targetEntity )
	{
		if (this.isSkillValid(_skill))
		{
			this.addRage(1);
		}
	}

	// We use onBeforeDamageReceived because it is guaranteed to run just before we receive damage and it also has access to the skill who dealt the damage
	q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitinfo, _properties )
	{
		__original(_attacker, _skill, _hitinfo, _properties);

		if (::MSU.isNull(_skill) == null) return;
		if (!_skill.isAttack()) return;
		if (_attacker == null) return;
		if (_attacker.isAlliedWith(this.getContainer().getActor())) return;

		this.addRage(1);
	}

	q.onMissed = @() function( _attacker, _skill )
	{
	}

	q.onCombatFinished = @() function()
	{
		this.m.HD_RageStacks = 0;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

		if (_target.getID() == this.getContainer().getActor().getID())	// We must be the _target
		{
			// Since any attack builds up rage stacks, it's generally a bad idea to attack into such a character, unless they have full stacks
			if (this.m.HD_RageStacks < this.m.HD_RageStacksMax)
			{
				ret *= 0.8;

				// It is an especially bad idea, if that target is stunned and very close to receiving the stun immunity from reaching full stacks
				if (this.m.HD_RageStacks + 1 == this.m.HD_RageStacksMax && _target.getCurrentProperties().IsStunned)
				{
					ret *= 0.8;
				}
			}

		}

		return ret;
	}

// New Functions
	q.isEnabled <- function()
	{
		return this.m.HD_RageStacks > 0;
	}

	// Is this skill valid to generate rage stacks when we hit with it and for receiving the Damage bonus?
	q.isSkillValid <- function( _skill )
	{
		return _skill != null && _skill.isAttack() && !_skill.isAOE();
	}

	q.addRage <- function( _rageStacks = 1 )
	{
		local oldStacks = this.m.HD_RageStacks
		this.m.HD_RageStacks = ::Math.clamp(this.m.HD_RageStacks + _rageStacks, 0, this.m.HD_RageStacksMax);

		local actor = this.getContainer().getActor();
		if (!actor.isHiddenToPlayer() && this.m.HD_RageStacks > oldStacks)
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Actor * 0.6, actor.getPos(), ::MSU.Math.randf(0.9, 1.1) * actor.getSoundPitch());
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " gains rage!");
		}
	}

	q.isMeetingThreshold <- function()
	{
		return this.m.HD_RageStacks >= this.m.HD_StackThreshold;
	}

	q.getDamageTotalMult <- function()
	{
		return 1.0 + (this.m.HD_RageStacks * this.m.HD_DamageTotalPctPerStack);
	}

	q.getDamageReceivedRegularMult <- function()
	{
		return this.isMeetingThreshold() ? this.m.HD_DamageReceivedRegularMult : 1.0;
	}

	q.isImmuneToStuns <- function()
	{
		return this.isMeetingThreshold();
	}
});
