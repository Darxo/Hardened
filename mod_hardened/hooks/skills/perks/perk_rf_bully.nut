::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bully", function(q) {
	// Public
	q.m.DamageTotalMult <- 1.1;			// This much damage bonus is granted against targets with lower morale
	q.m.MeleeDefenseModifier <- 5;		// This much melee defense is granted against targets with lower melee defense

	// Private
	q.m.SoundOnBully <- [		// This sound is played, when we dodge a melee attack only because of this perk
		"sounds/combat/taunt_01.wav",
		"sounds/combat/taunt_02.wav",
		"sounds/combat/taunt_03.wav",
		"sounds/combat/taunt_04.wav",
		"sounds/combat/taunt_05.wav",
	];

	// Overwrite, because we buff all types of damage
	q.onAnySkillUsed = @() function ( _skill, _targetEntity, _properties )
	{
		_properties.DamageTotalMult *= this.getDamageTotalMult(_targetEntity);
	}

	// Overwrite, because we completely redesign this perk anyways
	q.onBeingAttacked = @() function( _attacker, _skill, _properties )
	{
		_properties.MeleeDefense += this.getMeleeDefenseModifier(_attacker);
	}

	// Overwrite, because we completely redesign this perk anyways, so we dont take any risks of future reforged adjustments seeping in
	q.onMissed = @() function( _attacker, _skill )
	{
		if (!::MSU.isNull(::Hardened.Temp.LastAttackInfo) && _skill.isAttack() && !_skill.isRanged())
		{
			local meleeDefenseModifier = this.getMeleeDefenseModifier(_attacker);
			if (meleeDefenseModifier > 0 && (::Hardened.Temp.LastAttackInfo.Roll - meleeDefenseModifier <= ::Hardened.Temp.LastAttackInfo.ChanceToHit))
			{
				this.onBully();
			}
		}
	}

// MSU Functions
	// Overwrite, because even if Reforged had hitfactors, we display them under different conditions
	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip )
	{
		if (!_targetTile.IsOccupiedByActor) return;
		if (this.getDamageTotalMult(_targetTile.getEntity()) != 1.0)
		{
			_tooltip.push({
				icon = this.getIconColored(),
				text = this.getName(),
			});
		}
	}

	// Overwrite, because even if Reforged had hitfactors, we display them under different conditions
	q.onGetHitFactorsAsTarget = @() function( _skill, _targetTile, _tooltip )
	{
		if (!_skill.isAttack() || !_skill.isUsingHitchance() || _skill.isRanged()) return;	// This is just an approximation. In reality the perk grants +5 MDef against anything

		local meleeDefenseModifier = this.getMeleeDefenseModifier(_skill.getContainer().getActor());
		if (meleeDefenseModifier == 0) return;

		_tooltip.push({
			icon = "ui/tooltips/negative.png",
			text = ::MSU.Text.colorNegative(meleeDefenseModifier + "% ") + this.getName(),
		});
	}

// New Functions
	q.getDamageTotalMult <- function( _targetEntity )
	{
		if (::MSU.isNull(_targetEntity)) return 1.0;

		local targetMoraleState = _targetEntity.getMoraleState();
		// Usually "Ignore" is considered the highest state, but because it looks exactly like Steady and for design-reasons
		// we choose to treat it as "Steady" for the purpose of this perk
		if (targetMoraleState == ::Const.MoraleState.Ignore) targetMoraleState = ::Const.MoraleState.Steady;

		if (this.getContainer().getActor().getMoraleState() <= targetMoraleState) return 1.0;

		return this.m.DamageTotalMult;
	}

	q.getMeleeDefenseModifier <- function( _targetEntity )
	{
		if (::MSU.isNull(_targetEntity)) return 0;
		if (this.getContainer().getActor().getHitpointsMax() <= _targetEntity.getHitpointsMax()) return 0;

		return this.m.MeleeDefenseModifier;
	}

	// Triggered, when it is determined, that our bully perk was the deciding factor for avoiding a melee attack
	// This functions job is to visualize/animate this fact to the player (e.g. log, overlay icon, sfx, fx)
	q.onBully <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isHuman()) return;	// Our laugh-track is from a human only

		::Sound.play(::MSU.Array.rand(this.m.SoundOnBully), ::Const.Sound.Volume.Skill, actor.getPos());
	}
});
