::Hardened.HooksMod.hook("scripts/skills/actives/cascade_skill", function(q) {
	// Public
	q.m.HD_AttacksPerUse <- 2;	// Vanilla: 3
	q.m.HD_DamageTotalMult <- 0.5;	// Vanilla: 0.33333334

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 7 && entry.icon == "ui/icons/special.png")
			{
				entry.text = "Trigger " + ::MSU.Text.colorPositive(this.m.HD_AttacksPerUse - 1) + " additional Attack(s) during each use of this skill";
			}
		}

		if (this.m.HD_DamageTotalMult != 1.0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "Attacks deal " + ::MSU.Text.colorizeMultWithText(this.m.HD_DamageTotalMult) + " Damage",
			});
		}

		return ret;
	}

	// Overwrite, because we make the amount of Attacks per Skilluse moddable
	// This is an exact copy of the "onUse" implementation in hail_skill
	q.onUse = @() { function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectChop);

		local target = _targetTile.getEntity();
		// The active entity, will apply its attacks with a delay, if it, or its target is visible to the player
		if (_user.isActiveEntity() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			// We trigger the first attack without delay, because we want it to trigger with "IsDoingAttackMove = true"
			this.attackEntity(_user, target);

			local delay = 100;
			for (local i = 1; i < this.m.HD_AttacksPerUse; ++i, delay += 100)
			{
				this.getContainer().setBusy(true);

				::Time.scheduleEvent(::TimeUnit.Virtual, delay, function ( _skill )
				{
					_skill.m.IsDoingAttackMove = false;
					_skill.getContainer().setBusy(false);
					if (target.isAlive() && _user.isAlive())
					{
						_skill.attackEntity(_user, target);
					}
					_skill.m.IsDoingAttackMove = true;
				}.bindenv(this), this);
			}
			return true;	// We can't guarantee, that any attack hit, so the best we can do is just return true (Vanilla does the same)
		}
		else
		{
			local ret = false;
			for (local i = 0; i < this.m.HD_AttacksPerUse; ++i)
			{
				if (target.isAlive() && _user.isAlive())
				{
					ret = this.attackEntity(_user, target) || ret;
				}
			}
			return ret;
		}
	}}.onUse;

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageTotalMult *= this.m.HD_DamageTotalMult;
			// We no longer adjust the DamageTooltipMaxMult, as we now explicitely say in the tooltip, that this skill reduces the total damage
		}
	}
});
