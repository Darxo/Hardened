::Hardened.HooksMod.hook("scripts/skills/actives/strike_down_skill", function(q) {
	q.m.StunChance = 100;	// Vanilla: 75

	// Public:
	q.m.HD_StunDuration <- 1;	// Vanilla: 2
	q.m.HD_FatigueDealtPerHit <- 20.0;	// Vanilla: 20
	q.m.HD_DamageTotalMult <- 0.5;		// Vanilla: 0.5

	q.softReset = @(__original) function()
	{
		__original();
		this.m.StunChance = this.b.StunChance;
		this.m.HD_StunDuration = this.b.HD_StunDuration;
	}

	// Overwrite, because we streamline the vanilla tooltips and make them more moddable
	q.getTooltip = @() function()
	{
		local ret = this.getDefaultTooltip();

		if (this.m.HD_FatigueDealtPerHit != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Inflict " + ::MSU.Text.colorizeValue(this.m.HD_FatigueDealtPerHit, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Fatigue|Concept.Fatigue] on a hit"),
			});
		}

		if (this.m.StunChance > 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::MSU.Text.colorizeValue(this.m.StunChance, {AddPercent = true}) + ::Reforged.Mod.Tooltips.parseString(" chance to [Stun|Skill+stunned_effect] the target for " + ::MSU.Text.colorPositive(this.m.HD_StunDuration) + " [turn(s)|Concept.Turn] on a hit"),
			});
		}

		return ret;
	}

	// Overwrite, because we reimplement and extract the stun logic in order to make this skill more moddable
	q.onUse = @() function( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectBash);
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, target);
		if (success) this.HD_tryStun(_user, target);
		return success;
	}

	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.FatigueDealtPerHitMult += (this.m.HD_FatigueDealtPerHit / ::Const.Combat.FatigueReceivedPerHit);
			_properties.DamageTotalMult *= this.m.HD_DamageTotalMult;
		}
	}

// New Functions
	// Try to apply a stun to _target using this skills parameters
	// @return true, if the target has a longer stun on them after this function ran than before, or false otherwise
	q.HD_tryStun <- function( _user, _target )
	{
		if (!_target.isAlive()) return false;
		if (_target.getCurrentProperties().IsImmuneToStun) return false;
		if (::Math.rand(1, 100) > this.m.StunChance) return false;

		local stun = _target.getSkills().getSkillByID("effects.stunned");
		if (stun == null)
		{
			stun = ::new("scripts/skills/effects/stunned_effect");
			_target.getSkills().add(stun);
			stun.setTurns(this.m.HD_StunDuration);
		}
		else
		{
			if (stun.getTurns() >= this.m.HD_StunDuration) return false;
			stun.setTurns(this.m.HD_StunDuration);
		}

		if (!_user.isHiddenToPlayer() && !_target.isHiddenToPlayer())
		{
			::Tactical.EventLog.logEx(stun.getLogEntryOnAdded(::Const.UI.getColorizedEntityName(_user), ::Const.UI.getColorizedEntityName(_target)));
		}

		return true;
	}
});
