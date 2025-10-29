::Hardened.HooksMod.hook("scripts/skills/perks/perk_battle_flow", function(q) {
	q.onTargetKilled = @(__original) { function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();
		local oldFatigue = actor.getFatigue();
		__original(_targetEntity, _skill);
		local recoveredFatigue = oldFatigue - actor.getFatigue();

		if (recoveredFatigue > 0 && actor.isPlacedOnMap() && actor.getTile().IsVisibleForPlayer)
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " recovers " + ::MSU.Text.colorPositive(recoveredFatigue) + " Fatigue (" + this.getName() + ")");
		}
	}}.onTargetKilled;

	// Overwrite, because we no longer reset this effect on turn start
	q.onTurnStart = @() function() {}

	// This effect now resets on Round start so its effect works exactly as advertised on the perk description
	q.onNewRound = @(__original) function()
	{
		__original();

		this.m.IsSpent = false;
	}
});
