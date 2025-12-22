::Hardened.HooksMod.hook("scripts/skills/actives/rf_arrow_to_the_knee_skill", function(q) {
// Reforged Functions
	// Overwrite, because we allow undead to be affected by this skill now, if they can receive leg injuries
	q.RF_isTargetValid = @() function( _targetEntity )
	{
		if (!_targetEntity.getCurrentProperties().IsAffectedByInjuries) return false;

		// We remove the condition checking for the "Undead" flag on the entity

		local legInjuries = ::Const.Injury.ExcludedInjuries.get(::Const.Injury.ExcludedInjuries.Leg);
		return legInjuries.filter(@(_, _id) _targetEntity.m.ExcludedInjuries.find(_id) == null).len() > 0;
	}
});
