::Hardened.HooksMod.hook("scripts/skills/injury/injury", function(q) {
	q.onDeserialize = @(__original) function( _out )
	{
		__original(_out);
		this.m.IsNew = false;	// Vanilla Fix: support IsNew member for injuries as this is not serialized for them in vanilla
	}

// New Functions
	q.HD_isAffectedByInjuries <- function( _properties )
	{
		if (!_properties.IsAffectedByInjuries) return false;;
		if (this.m.IsFresh && !_properties.IsAffectedByFreshInjuries) return false;

		return true;
	}
});
