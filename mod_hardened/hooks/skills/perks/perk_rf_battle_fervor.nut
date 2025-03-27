::Hardened.wipeClass("scripts/skills/perks/perk_rf_battle_fervor", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_battle_fervor", function(q) {
	// Public
	q.m.BraveryMult <- 1.1;
	q.m.CombatStatMult <- 1.1;

	q.create = @(__original) function()
	{
		__original();
		this.removeType(::Const.SkillType.StatusEffect);
	}

	q.onUpdate <- function( _properties )
	{
		_properties.BraveryMult *= this.m.BraveryMult;
		if (this.isEnabled())
		{
			_properties.MeleeSkillMult *= this.m.CombatStatMult;
			_properties.RangedSkillMult *= this.m.CombatStatMult;
			_properties.MeleeDefenseMult *= this.m.CombatStatMult;
			_properties.RangedDefenseMult *= this.m.CombatStatMult;
		}
	}

// New Functions
	q.isEnabled <- function()
	{
		return this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Steady;
	}
});
