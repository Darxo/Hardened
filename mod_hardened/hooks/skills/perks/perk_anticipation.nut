::Hardened.HooksMod.hook("scripts/skills/perks/perk_anticipation", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = ::MSU.String.replace(this.m.Description, "attacks against you,", "attacks against you or your shield,");
	}

// Hardened Events
	q.onBeforeShieldDamageReceived = @() function( _damage, _shield, _defenderProps, _attacker, _attackerProps, _skill )
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

	q.onAfterShieldDamageReceived = @() function( _initialDamage, _damageReceived, _shield, _attacker, _skill )
	{
		if (this.m.IsAboutToConsumeUse == false) return;	// We only consume one use for each registered attack. But a single attack that deals damage multiple times will therefor have the damage of all instances reduced
		this.m.IsAboutToConsumeUse = false;

		this.m.UsesRemaining = ::Math.max(0, this.m.UsesRemaining - 1);

		if (_attacker == null)	// This can for example happen when this character receives a mortar attack.
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " anticipated an attack on their shield, reducing incomding damage by " + ::MSU.Text.colorPositive(this.m.TempDamageReduction + "%"));
		}
		else
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " anticipated the attack of " + ::Const.UI.getColorizedEntityName(_attacker) + " on their shield, reducing incomding damage by " + ::MSU.Text.colorPositive(this.m.TempDamageReduction + "%"));
		}
	}
});
