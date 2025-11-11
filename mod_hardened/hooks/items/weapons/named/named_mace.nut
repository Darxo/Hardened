::Hardened.HooksMod.hook("scripts/items/weapons/named/named_mace", function(q) {
	q.updateVariant = @(__original) function()
	{
		__original();

		// Vanilla Fix: We adjust the brush art of named_mace as vanilla has mixed them up.
		// Variants 1/5 and 2/4 have the same outline but slightly different texture
		local armamentVariant = this.m.Variant;
		switch (armamentVariant)
		{
			case 1:
				armamentVariant = 5;
				break;
			case 2:
				armamentVariant = 4;
				break;
			case 4:
				armamentVariant = 2;
				break;
			case 5:
				armamentVariant = 1;
				break;
		}

		this.m.ArmamentIcon = "icon_named_mace_0" + armamentVariant;
	}
});
