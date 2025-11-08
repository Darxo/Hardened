::Hardened.HooksMod.hook("scripts/skills/effects/poison_coat_effect", function (q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav",
		];
	}}.create;
});
