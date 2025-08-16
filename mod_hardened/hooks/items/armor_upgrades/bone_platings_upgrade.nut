::Hardened.HooksMod.hook("scripts/items/armor_upgrades/bone_platings_upgrade", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		this.adjustHitIgnoreTooltip(ret);
		return ret;
	}

	q.onArmorTooltip = @(__original) function( _result )
	{
		__original(_result);
		this.adjustHitIgnoreTooltip(_result);
	}

// New Functions
	q.adjustHitIgnoreTooltip <- function( _tooltip )
	{
		foreach (index, entry in _tooltip)
		{
			if (entry.id == 14 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Absorb the first Body hit each combat, which does not ignore armor");
				break;
			}
		}
	}
});

