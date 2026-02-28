::Hardened.HooksMod.hook("scripts/skills/actives/slash_lightning", function(q) {
	q.m.HD_LightningDamageMin <- 10;
	q.m.HD_LightningDamageMax <- 15;

	q.create = @(__original) function()
	{
		__original();
		this.m.HitChanceBonus -= 10;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 7)
			{
				ret.remove(index);
				break;
			}
		}

		foreach (entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/special.png")
			{
				entry.text = "During your turn, if you hit your target, deal an additional " + ::MSU.Text.colorNegative(this.m.HD_LightningDamageMin) + " - " + ::MSU.Text.colorNegative(this.m.HD_LightningDamageMax) + " fire damage, ignoring armor, to the head of your target and up to two nearby enemies";
				break;
			}
		}

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.MeleeSkill -= 10;	// This reverts the vanilla +10 Modifier
		}
	}

	// Overwrite, because changing anything in the events scheduled by vanilla is very tricky
	q.applyEffect = @() function( _data, _delay )
	{
		// Animation
		::Time.scheduleEvent(::TimeUnit.Virtual, _delay, function ( _data )
		{
			for (local i = 0; i < ::Const.Tactical.LightningParticles.len(); ++i)
			{
				::Tactical.spawnParticleEffect(true, ::Const.Tactical.LightningParticles[i].Brushes, _data.TargetTile, ::Const.Tactical.LightningParticles[i].Delay, ::Const.Tactical.LightningParticles[i].Quantity, ::Const.Tactical.LightningParticles[i].LifeTimeQuantity, ::Const.Tactical.LightningParticles[i].SpawnRate, ::Const.Tactical.LightningParticles[i].Stages);
			}
		}, _data);

		// If the targeted tile is empty, we still play the animation, but deal no damage
		if (_data.Target == null) return;

		_delay += 200;	// We add an additional 200ms delay so that the damage more realistically is applied after the animation happend
		::Time.scheduleEvent(::TimeUnit.Virtual, _delay, function ( _data )
		{
			// Switcheroo of IsAttack, so that the lightning damage is considered non-attack damage is is not mitigated by Nimble and such
			local oldIsAttack = _data.Skill.m.IsAttack;
			_data.Skill.m.IsAttack = false;
			_data.Target.onDamageReceived(_data.User, _data.Skill, _data.Skill.HD_getLightningHitInfo());
			_data.Skill.m.IsAttack = oldIsAttack;

		}, _data);
	}

// New Functions
	q.HD_getLightningHitInfo <- function()
	{
		local hitInfo = clone ::Const.Tactical.HitInfo;

		hitInfo.DamageRegular = ::Math.rand(this.m.HD_LightningDamageMin, this.m.HD_LightningDamageMax);	// Vanilla: 10, 20
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Head;	// Vanilla: Body
		hitInfo.BodyDamageMult = ::Const.CharacterProperties.DamageAgainstMult[hitInfo.BodyPart];	// Vanilla: 1.0
		hitInfo.FatalityChanceMult = 0.0;

		// These values are new compared to vanilla,
		// We don't change the injury type, because burning injuries to the head have a very limited pool and would end up bland to always see the same injury
		hitInfo.DamageType = ::Const.Damage.DamageType.Burning;		// MSU value

		return hitInfo;
	}
});
