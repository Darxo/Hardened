this.hd_feral_rage_effect <- this.inherit("scripts/skills/skill", {
	m = {
		// Public
		DamageTotalPctPerStack = 0.25,
		RageStacksMax = 4,

		StackThreshold = 4,		// When you have at least this many stacks, unlock a bonus effect
		DamageReceivedRegularMult = 0.8,	// Hitpoint Damage Mitigation from Attacks when meeting stack threshold

		// Private
		RageStacks = 1,		// This many stacks of rage do we have currently

	},

	function create()
	{
		this.m.ID = "effects.hd_feral_rage";
		this.m.Name = "Feral Rage";
		this.m.Description = "You are consumed by uncontrollable rage.";
		this.m.Icon = "skills/status_effect_34.png";
		this.m.IconMini = "status_effect_34_mini";
		this.m.Overlay = "status_effect_34";
		this.m.SoundOnUse = [
			"sounds/combat/rage_01.wav",
			"sounds/combat/rage_02.wav",
		];
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		return this.skill.getName() + " (" + this.m.RageStacks + "/" + this.m.RageStacksMax + ")";
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = ::Reforged.Mod.Tooltips.parseString("Deal " + ::MSU.Text.colorizePct(this.m.DamageTotalPctPerStack) + " more Damage with Non-AoE Attacks for each Rage Stack"),
			});
		}
		else if (this.getDamageTotalMult() != 1.0)
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
		else
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/icon_locked.png",
				text = ::Reforged.Mod.Tooltips.parseString("While you have at least " + ::MSU.Text.colorNeutral(this.m.StackThreshold) + " Rage Stacks, take " + ::MSU.Text.colorizeMultWithText(this.m.DamageReceivedRegularMult, {InvertColor = true}) + " less [Hitpoint|Concept.Hitpoints] Damage"),
			});
		}

		if (this.isImmuneToStuns())
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Immune to [$ $|Concept.Stunned]"),
			});
		}
		else
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/icon_locked.png",
				text = ::Reforged.Mod.Tooltips.parseString("While you have at least " + ::MSU.Text.colorNeutral(this.m.StackThreshold) + " Rage Stacks, become Immune to [$ $|Concept.Stunned]"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lose all Rage Stacks when you hit with a Non-AoE Attack"),
		});

		return ret;
	}

	function onAdded()
	{
		this.onAddedRageStack();
	}

	function onUpdate( _properties )
	{
		_properties.ShowFrenzyEyes = true;
		_properties.DamageReceivedRegularMult *= this.getDamageReceivedRegularMult();

		if (this.isImmuneToStuns()) _properties.IsImmuneToStun = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.isSkillValid(_skill))
		{
			_properties.DamageTotalMult *= this.getDamageTotalMult();
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!this.isSkillValid(_skill)) return;

		this.removeSelf();
		local actor = this.getContainer().getActor();
		::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Actor * 1.0, actor.getPos(), ::MSU.Math.randf(0.9, 1.1) * actor.getSoundPitch());
	}

	function onRefresh()
	{
		if (this.m.RageStacks >= this.m.RageStacksMax) return;

		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
		++this.m.RageStacks;
		this.onAddedRageStack();
	}

// Modular Vanilla Functions
	// Remove?
	function getQueryTargetValueMult( _user, _target, _skill )
	{
		local ret = 1.0;
		if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

		if (_target.getID() == this.getContainer().getActor().getID())	// We must be the _target
		{
			// Since any attack builds up rage stacks, it's generally a bad idea to attack into such a character, unless they have full stacks
			if (this.m.RageStacks < this.m.RageStacksMax)
			{
				ret *= 0.8;

				// It is an especially bad idea, if that target is stunned and very close to receiving the stun immunity from reaching full stacks
				if (this.m.RageStacks + 1 == this.m.RageStacksMax && _target.getCurrentProperties().IsStunned)
				{
					ret *= 0.8;
				}
			}
		}

		return ret;
	}

// New Functions
	// Is this skill valid to generate rage stacks when we hit with it and for receiving the Damage bonus?
	function isSkillValid( _skill )
	{
		return _skill != null && _skill.isAttack() && !_skill.isAOE();
	}

	function onAddedRageStack()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isHiddenToPlayer())
		{
			::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Actor * 0.6, actor.getPos(), ::MSU.Math.randf(0.9, 1.1) * actor.getSoundPitch());
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " gains rage!");
		}
	}

	function isMeetingThreshold()
	{
		return this.m.RageStacks >= this.m.StackThreshold;
	}

	function getDamageTotalMult()
	{
		return 1.0 + (this.m.RageStacks * this.m.DamageTotalPctPerStack);
	}

	function getDamageReceivedRegularMult()
	{
		return this.isMeetingThreshold() ? this.m.DamageReceivedRegularMult : 1.0;
	}

	function isImmuneToStuns()
	{
		return this.isMeetingThreshold();
	}
});
