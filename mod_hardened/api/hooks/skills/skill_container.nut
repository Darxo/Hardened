::Hardened.HooksMod.hook("scripts/skills/skill_container", function(q) {
// New Events
	/// _skill is the new skill that was just added to this skill_container
	q.onOtherSkillAdded <- function( _skill )
	{
		this.callSkillsFunction("onOtherSkillAdded", [
			_skill
		], false);
	}

	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		this.callSkillsFunction("onReallyBeforeSkillExecuted", [
			_skill,
			_targetTile,
		], false);
	}

	q.onReallyAfterSkillExecuted <- function( _skill, _targetTile, _success )
	{
		this.callSkillsFunction("onReallyAfterSkillExecuted", [
			_skill,
			_targetTile,
			_success,
		], false);
	}

	// This event is called when this entity is spawned and placed on the map
	q.onSpawned <- function()
	{
		this.callSkillsFunction("onSpawned", [], false);
	}

	q.onBeforeShieldDamageReceived <- function( _damage, _shield, _defenderProps, _attacker = null, _attackerProps = null, _skill = null )
	{
		this.callSkillsFunction("onBeforeShieldDamageReceived", [
			_damage,
			_shield,
			_defenderProps,
			_attacker,
			_attackerProps,
			_skill,
		], false);
	}

	q.onAfterShieldDamageReceived <- function( _initialDamage, _damageReceived, _shield, _attacker = null, _skill = null )
	{
		this.callSkillsFunction("onAfterShieldDamageReceived", [
			_initialDamage,
			_damageReceived,
			_shield,
			_attacker,
			_skill,
		], false);
	}
});
