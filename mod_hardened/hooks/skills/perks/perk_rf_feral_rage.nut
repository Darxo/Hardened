::Hardened.wipeClass("scripts/skills/perks/perk_rf_feral_rage", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_feral_rage", function(q) {

	q.create = @(__original) function()
	{
		__original();
		this.m.Type = ::Const.SkillType.Perk;
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

		if (::MSU.isNull(_skill)) return;
		if (!_skill.isAttack()) return;
		if (_attacker == null) return;
		if (_attacker.isAlliedWith(this.getContainer().getActor())) return;

		this.addRage(1);
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		return _skill != null && _skill.isAttack() && !_skill.isAOE();
	}

	q.addRage <- function( _rageStacks = 1 )
	{
		for (local i = 1; i <= _rageStacks; ++i)
		{
			local rageEffect = ::new("scripts/skills/effects/hd_feral_rage_effect");
			this.getContainer().add(rageEffect);
		}
	}
});
