::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function(q) {
	q.m.PossibleSkills.push("actives.hd_vampire_bite");
	q.m.PossibleSkills.push("actives.hd_zombie_punch_skill");
});
