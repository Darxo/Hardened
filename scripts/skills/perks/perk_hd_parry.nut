this.perk_hd_parry <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		BaseRangeDefenseAsMeleeDefensePct = 1.0,	// This much of the Base Ranged Defense is added to Melee Defense while engaged with a weapon wielder
		RangedDefenseMultWhenEngaged = 0.3,

		// Private
		SoundOnParry = ::Const.Sound.ShieldHitMetal,
	},
	function create()
	{
		this.m.ID = "perk.hd_parry";
		this.m.Name = ::Const.Strings.PerkName.HD_Parry;
		this.m.Description = "Your attention is fully on deflecting weapon strikes, making it potentially harder to guard against distant threats.";
		this.m.Icon = "ui/perks/perk_hd_parry.png";
		this.m.IconMini = "perk_hd_parry_mini";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local meleeDefenseModifier = this.getMeleeDefenseModifier();
		if (meleeDefenseModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorizeValue(meleeDefenseModifier, {AddSign = true}) + " [Melee Defense|Concept.MeleeDefense] against Weapon Attacks"),
			});
		}

		if (this.m.RangedDefenseMultWhenEngaged != 1.0 && this.isEnabledRangedLoss())
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedDefenseMultWhenEngaged) + " [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		return ret;
	}

	function isHidden()
	{
		return !this.isEnabled();
	}

	function onUpdate( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this effect reduces ranged defense depending on adjacent enemies
		if (this.isEnabledRangedLoss())
		{
			_properties.RangedDefenseMult *= this.m.RangedDefenseMultWhenEngaged;
			this.m.IsHidingIconMini = false;
		}
		else
		{
			this.m.IsHidingIconMini = true;
		}
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (this.isSkillParryable(_skill))
		{
			_properties.MeleeDefense += this.getMeleeDefenseModifier();
		}
	}

	function onMissed( _attacker, _skill )
	{
		if (!::MSU.isNull(::Hardened.Temp.LastAttackInfo))
		{
			if (this.isSkillParryable(_skill))
			{
				// parryChance is an approximation of how much this perk contributed to us dodging. It's not accurate because vanilla halves the melee defense above 50
				local parryChance = ::Math.round(this.getMeleeDefenseModifier() * ::Hardened.Temp.LastAttackInfo.PropertiesForDefense.MeleeDefenseMult);

				// Our Parry perk was the deciding factor to make us dodge this attack
				if (::Hardened.Temp.LastAttackInfo.Roll - parryChance <= ::Hardened.Temp.LastAttackInfo.ChanceToHit)
				{
					this.onParry(_attacker);
				}
			}
		}
	}

	function addResources()
	{
		this.skill.addResources();

		foreach (resource in this.m.SoundOnParry)
		{
			::Tactical.addResource(resource);	// Make it so these sfx will actually loaded and able to be played
		}
	}

// MSU Functions
	function onGetHitFactorsAsTarget( _skill, _targetTile, _tooltip )
	{
		if (this.isSkillParryable(_skill))
		{
			_tooltip.push({
				icon = "ui/tooltips/negative.png",
				text = ::MSU.Text.colorNegative((this.getMeleeDefenseModifier()) + "% ") + this.getName(),
			});
		};
	}

// Modular Vanilla Functions
	function getQueryTargetValueMult( _user, _target, _skill )
	{
		local ret = 1.0;

		if (_target.getID() == this.getContainer().getActor().getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			if (_skill == null) return ret;

			if (_skill.getID() == "actives.disarm")
				ret *= 1.2;	// _user is encouraged to disarm us to disable this perks bonus

			if (_skill.getID() == "actives.knock_out" || _skill.getID() == "actives.knock_over_skill")
				ret *= 1.2;	// _user is encouraged to stun us to disable this perks bonus
		}

		return ret;
	}

// New Functions
	function getMeleeDefenseModifier()
	{
		local meleeDefenseModifier = this.getContainer().getActor().getBaseProperties().RangedDefense * this.m.BaseRangeDefenseAsMeleeDefensePct;
		return ::Math.max(0, ::Math.round(meleeDefenseModifier));
	}

	// Requirements for the Ranged Defense reduction to be active
	function isEnabledRangedLoss()
	{
		if (!this.isEnabled()) return false;

		// Check, if we are adjacent to another person with a melee weapon
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap())
		{
			local adjacentHostile = ::Tactical.Entities.getHostileActors(actor.getFaction(), actor.getTile(), 1, true);
			foreach (enemy in adjacentHostile)
			{
				local mainhandItem = enemy.getMainhandItem();
				if (mainhandItem != null && mainhandItem.isItemType(::Const.Items.ItemType.MeleeWeapon))
				{
					return true;
				}
			}
		}
		return false;
	}

	// Requirements for an incoming skill to trigger the Melee Defense Bonus
	function isSkillParryable( _skill )
	{
		if (!this.isEnabled()) return false;

		local item = _skill.getItem();
		if (!::MSU.isNull(item) && item.isItemType(::Const.Items.ItemType.MeleeWeapon) && _skill.isAttack())
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	// Minimum shared requirements for any of this perks effects to work
	function isEnabled()
	{
		local actor = this.getContainer().getActor();
		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing) return false;
		if (actor.getCurrentProperties().IsStunned) return false;
		if (actor.isDisarmed()) return false;
		if (actor.isArmedWithShield()) return false;

		local mainhandItem = actor.getMainhandItem();
		if (mainhandItem == null) return false;
		if (!mainhandItem.isItemType(::Const.Items.ItemType.MeleeWeapon)) return false;	// User needs a melee weapon equipped
		if (!mainhandItem.isItemType(::Const.Items.ItemType.OneHanded)) return false;	// User needs a one-handed weapon

		return true;
	}

	// Triggered, when it is determined, that our parry skill was the deciding factor for avoiding an attack
	// This functions job is to visualize this fact to the player (e.g. log, overlay icon, sfx, fx)
	function onParry( _attacker )
	{
		local actor = this.getContainer().getActor();

		// Play sound
		::Sound.play(::MSU.Array.rand(this.m.SoundOnParry), ::Const.Sound.Volume.Skill, actor.getPos());

		// Generate particle effect
		foreach (particles in ::Const.Tactical.HD_ParrySparkles)
		{
			if ("init" in particles) particles.init(actor.getTile(), _attacker.getTile());	// init adjusts the offset according to where the hit is coming from
			::Tactical.spawnParticleEffect(false, particles.Brushes, actor.getTile(), particles.Delay, particles.Quantity, particles.LifeTimeQuantity, particles.SpawnRate, particles.Stages);
		}
	}
});
