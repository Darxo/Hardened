::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_swing", function(q) {
	q.m.PossibleSkills.push("actives.hd_trickster_sweep");
});
