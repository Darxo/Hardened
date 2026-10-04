::Hardened.HooksMod.hook("scripts/skills/special/rf_undead_injury_receiver", function(q) {
	// We disable the injury threshold bonus for undeads/skeletons
	q.m.ThresholdToReceiveInjuryMult = 1.0;		// Reforged: 1.33
});
