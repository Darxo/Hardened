::Hardened.HooksMod.hook("scripts/skills/actives/sling_stone_skill", function(q) {
	q.m.HD_UsableWhileEngagedInMelee = false;
});
