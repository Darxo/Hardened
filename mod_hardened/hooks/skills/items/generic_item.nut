::Hardened.HooksMod.hook("scripts/skills/items/generic_item", function(q) {
	q.onUpdate = @(__original) function( _properties )
	{
		// Vanilla Fix: incomplete isNull check, by streamlining the value of this.m.Item to the one which Vanilla checks for
		// this.m.Item contains a WeakTableRef in Vanilla but they fail to do an .isNull() check on it
		if (::MSU.isNull(this.m.Item))
		{
			this.m.Item = null;
		}

		// Revert vanilla Stamina change as we manage that ourselves now from within actor.nut
		local oldStamina = _properties.Stamina;
		__original(_properties);
		_properties.Stamina = oldStamina;
	}

	q.onTurnStart = @(__original) { function onTurnStart()
	{
		// Vanilla Fix: incomplete isNull check, by streamlining the value of this.m.Item to the one which Vanilla checks for
		// this.m.Item contains a WeakTableRef in Vanilla but they fail to do an .isNull() check on it
		if (::MSU.isNull(this.m.Item))
		{
			this.m.Item = null;
		}

		__original();
	}}.onTurnStart;
});
