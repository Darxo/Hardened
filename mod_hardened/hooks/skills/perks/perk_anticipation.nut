::Hardened.HooksMod.hook("scripts/skills/perks/perk_anticipation", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::MSU.String.replace(this.m.Description, "attacks against you,", "attacks against you or your shield,");
		this.m.Overlay = "perk_anticipation";
	}

	q.onDamageReceived = @(__original) function( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.m.IsAboutToConsumeUse)
		{
			this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
		}

		__original(_attacker, _damageHitpoints, _damageArmor);
	}

// Hardened Events
	q.onBeforeShieldDamageReceived = @() function( _damage, _shield, _defenderProps, _attacker = null, _attackerProps = null, _skill = null )
	{
		if (!this.isEnabled() || _skill == null || !_skill.isAttack())		// This event does not guarantee that _skill is != null
		{
			this.m.IsAboutToConsumeUse = false;
			return;
		}

		this.m.TempDamageReduction = this.calculateDamageReduction(_attacker);		// We save this so that we can later display it in the combat log
		_defenderProps.ShieldDamageReceivedMult *= (1.0 - (this.m.TempDamageReduction / 100.0));

		this.m.IsAboutToConsumeUse = true;	// We use this variable to save some checks during onAfterShieldDamageReceived
	}

	q.onAfterShieldDamageReceived = @() function( _initialDamage, _damageReceived, _shield, _attacker = null, _skill = null )
	{
		if (this.m.IsAboutToConsumeUse == false) return;	// We only consume one use for each registered attack. But a single attack that deals damage multiple times will therefor have the damage of all instances reduced
		this.m.IsAboutToConsumeUse = false;

		this.m.UsesRemaining = ::Math.max(0, this.m.UsesRemaining - 1);

		local actor = this.getContainer().getActor();
		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon(this.m.Overlay, actor.getTile());
			if (_attacker == null)	// This can for example happen when this character receives a mortar attack.
			{
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " anticipated an attack on their shield, reducing incoming damage by " + ::MSU.Text.colorPositive(this.m.TempDamageReduction + "%"));
			}
			else
			{
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " anticipated the attack of " + ::Const.UI.getColorizedEntityName(_attacker) + " on their shield, reducing incoming damage by " + ::MSU.Text.colorPositive(this.m.TempDamageReduction + "%"));
			}
		}
		actor.setDirty(true);
	}
});
