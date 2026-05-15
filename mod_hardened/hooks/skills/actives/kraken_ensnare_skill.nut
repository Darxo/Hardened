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
});
