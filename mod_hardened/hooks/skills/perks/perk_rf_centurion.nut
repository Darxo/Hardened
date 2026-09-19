::Hardened.wipeClass("scripts/skills/perks/perk_rf_centurion", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_centurion", function(q) {
	q.m.HD_Radius <- 4;

	q.onUpdate = @() { function onUpdate( _properties )
	{
		_properties.TargetAttractionMult *= 2.0;
		_properties.UpdateWhenTileOccupationChanges = true;

		if (this.HD_isEnabled())
		{
			this.scanForAuraTargets();
		}
	}}.onUpdate;

// New Functions
	q.scanForAuraTargets <- function()
	{
		local actor = this.getContainer().getActor();
		foreach (target in ::Tactical.Entities.getAllInstancesAsArray())
		{
			if (!this.HD_isTargetValid(target)) continue;

			local existingEffect = target.getSkills().getSkillByID("effects.rf_centurion_command");
			if (existingEffect != null)
			{
				if (existingEffect.HD_isSourceValid()) continue;

				// Fix an edge case with multiple aura provider, when the main provider moves away from a target
				//	but another aura provider nearby
				// Depending on skill update order, the aura effect might be removed too late, so that the other aura provider does not take over
				// We fix that by removing the skill instantly, if we notice right here that it is no longer valid
				existingEffect.removeSelf();
			}

			local auraEffect = ::new("scripts/skills/effects/rf_centurion_command_effect");
			auraEffect.m.HD_AuraSource = ::MSU.asWeakTableRef(actor);
			auraEffect.m.HD_SourcePerkID = this.getID();
			target.getSkills().add(auraEffect);
		}
	}

	// Is this perk enabled and this actor able to exert their aura?
	q.HD_isEnabled <- function()
	{
		if (!::Tactical.isActive()) return false;

		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;

		return true;
	}

	q.HD_isTargetValid <- function( _target )
	{
		local actor = this.getContainer().getActor();
		if (::MSU.isEqual(_target, actor)) return false;		// We don't affect ourselves
		if (!_target.isAlliedWith(actor)) return false;			// Target must be allied

		if (!_target.isPlacedOnMap()) return false;

		local distance = _target.getTile().getDistanceTo(actor.getTile());
		if (distance > this.m.HD_Radius) return false;							// Target must be a in range

		if (!_target.getSkills().hasSkill("racial.skeleton")) return false;		// Target must be a skeleton

		return true;
	}
});
