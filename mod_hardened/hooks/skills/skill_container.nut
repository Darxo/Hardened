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

// New Functions
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
});
