this.hd_intoxication_effect <- ::inherit("scripts/skills/skill", {
	m = {
	// Public
		ToxicDamagePctPerStack = 0.50,
		DefaultStacks = 1,		// This many stacks are there by default or added when stacking this debuff
		StacksGainedPerIdleRound = -1,		// This many stacks are lost each round in which no toxic damage was taken

	// Private
		Stacks = 0,
		HasTakenToxicDamageThisRound = true,	// We set this to true by default to prevent this effect from being removed the turn its added
	},

	function create()
	{
		this.m.ID = "effects.hd_intoxication";
		this.m.Name = "Intoxication";
		this.m.Description = "";

		this.m.Icon = "skills/status_effect_00.png";	// Same icon as Miasma trigger
		this.m.Overlay = "status_effect_00";	// Same icon as Miasma trigger

		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;

		this.m.Stacks = this.m.DefaultStacks;
	}

	function getName()
	{
		return this.skill.getName() + " (x" + this.m.Stacks + ")";
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/hd_toxic_damage.png",	// Green blood droplet
			text = ::Reforged.Mod.Tooltips.parseString("Take " + ::MSU.Text.colorizeMultWithText(this.getToxicDamageMult(), {InvertColor = true}) + " Toxic Damage"),
		});

		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("At the end of each [round|Concept.Round], if you have not taken Toxic Damage this [round|Concept.Round], lose 1 Stack"),
		});

		return ret;
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsImmuneToPoison)
		{
			this.removeSelf();
		}
	}

	function onRefresh()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsImmuneToPoison)
		{
			this.removeSelf();
			return;
		}

		this.addStacks(this.m.DefaultStacks);
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (!this.getContainer().getActor().isAlive()) return;
		if (_damageHitpoints == 0 && _damageArmor == 0) return;

		local hitInfo = ::Tactical.State.MV_getCurrentHitInfo();
		if (hitInfo.DamageType != ::Const.Damage.DamageType.Toxic) return;

		this.m.HasTakenToxicDamageThisRound = true;
	}

	function onRoundEnd()
	{
		if (this.m.HasTakenToxicDamageThisRound)
		{
			this.m.HasTakenToxicDamageThisRound = false;
		}
		else
		{
			this.addStacks(this.m.StacksGainedPerIdleRound);
		}
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().getCurrentProperties().IsImmuneToPoison)
		{
			this.removeSelf();
			return;
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_hitInfo.DamageType == ::Const.Damage.DamageType.Toxic)
		{
			_properties.DamageReceivedTotalMult *= this.getToxicDamageMult();
		}
	}

// New Functions
	function getToxicDamageMult()
	{
		return 1.0 + this.m.Stacks * this.m.ToxicDamagePctPerStack;
	}

	function addStacks( _stacks, _playAnimation = false )
	{
		this.m.Stacks += _stacks;
		if (this.m.Stacks <= 0)
		{
			this.removeSelf();
		}
	}
});
