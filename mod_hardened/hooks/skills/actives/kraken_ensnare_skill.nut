::Hardened.HooksMod.hook("scripts/skills/actives/kraken_ensnare_skill", function(q) {
	// Fix: We only allow Kraken Tentacles to ensnare during the first phase of the fight
	// This fixes an AI issue where the second phase Tentacles would prioritize ensnaring over attacking
	// Vanilla already recognized the problem, that ai_attack_throw_net produces much bigger scores than ai_attack_default
	//	They tried to fix that by giving AttackDefault for Tentacle Agent a ScoreMult of 2.5
	// But with the reworked ai_attack_throw_net score in Hardened, which also includes the targets Melee Defense, that ScoreMult is not enough anymore
	// So we decide, that tentacles simple can't ensnare anymore in Phase 2
	q.isUsable = @(__original) function()
	{
		return __original() && this.getContainer().getActor().getMode() == 0;
	}

	// Overwrite, because we need to replace one use of "TimeUnit.Real" with "TimeUnit.Virtual"
	q.onUse = @() function( _user, _targetTile )
	{
		// Fix(Vanilla): Kraken Crash when playing at higher swifter speed
		_user.sinkIntoGround(0.75);
		_user.getSkills().setBusy(true);
		_user.m.IsAbleToDie = false;
		::Time.scheduleEvent(::TimeUnit.Virtual, 800, this.onNetSpawn.bindenv(this), {
			User = _user,
			Skill = this,
			TargetEntity = _targetTile.getEntity(),
			LoseHitpoints = true
		});
		return true;
	}
});
