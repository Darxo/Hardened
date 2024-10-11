::Hardened.HooksMod.hook("scripts/skills/skill_container", function(q) {
// Reforged Functions
	q.onDeath = @(__original) function( _fatalityType )
	{
		// Outside of battle items are now always moved to the stash, when the actor "dies" (as in leaving the company and world)
		if (!::MSU.Utils.hasState("tactical_state"))
		{
			this.getActor().getItems().transferToStash(::World.Assets.getStash());
		}

		__original(_fatalityType);
	}

// New Events
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
