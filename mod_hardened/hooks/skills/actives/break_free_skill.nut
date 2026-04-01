::Hardened.HooksMod.hook("scripts/skills/actives/break_free_skill", function(q) {
	// Public
	q.m.HD_BaseChance <- -20;	// Vanilla: 0
	q.m.HD_ChanceBonusPerFail <- 30;	// Vanilla: 10; ChanceBonus is increased by this value whenever this characters net fails to get broken free

	q.create = @(__original) function()
	{
		__original();

		this.m.ActionPointCost = 3;		// Vanilla: 4
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		// We revert the ChanceBonus to prevent Vanilla or any mod from increasing it, as we want to control that feature now
		local oldChanceBonus = this.m.ChanceBonus;
		local ret = __original(_user, _targetTile);
		this.m.ChanceBonus = oldChanceBonus;

		// Feat: We make the chance bonus moddable, that you gain per fail
		this.m.ChanceBonus += this.m.HD_ChanceBonusPerFail;

		return ret;
	}

	q.getChance = @(__original) function()
	{
		// Feat: We make the base chance for breaking free moddable
		return ::Math.clamp(__original() + this.m.HD_BaseChance, 0, 100);
	}
});
