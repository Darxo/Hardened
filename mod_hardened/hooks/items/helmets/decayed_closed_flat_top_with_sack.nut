::Hardened.HooksMod.hook("scripts/items/helmets/decayed_closed_flat_top_with_sack", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 1250
		this.m.ConditionMax = 220;		// Vanilla: 230
		this.m.StaminaModifier = -18;	// Vanilla: -19
		this.m.Vision = -3;				// Vanilla: -3

		// We change this item to look like its non-sack counterpart to reduce confusion
		this.m.Name = "Decayed Closed Flat Top with Mail";
		this.m.Description = "A worn and torn closed helmet with complete faceguard and a mail coif covering the neck. It has obviously been lying outdoors for a while.";
		this.m.Variant = ::MSU.Array.rand([55, 58, 61]);
		this.updateVariant();
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		if (this.m.Variant == 57)
		{
			this.m.Variant = ::MSU.Array.rand([55, 58, 61]);
			this.updateVariant();
		}
	}
});
