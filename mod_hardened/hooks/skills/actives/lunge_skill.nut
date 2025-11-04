::Hardened.HooksMod.hook("scripts/skills/actives/lunge_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.HitChanceBonus += 10;	// The hitchance bonus from the Fencer perk is moved here
		this.m.HD_IgnoreForCrowded = true;	// This skill moves during its execution ending with a regular attack on an adjacent tile so we exclude it from crowded
	}
});
