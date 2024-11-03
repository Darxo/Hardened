::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 64 && entry.icon == "ui/icons/direct_damage.png")
			{
				entry.text = ::MSU.String.replace(entry.text, "of damage ignores armor", ::Reforged.Mod.Tooltips.parseString("[Armor Penetration|Concept.ArmorPenetration]"));
			}
			else if (entry.id == 10 && entry.icon == "ui/icons/ammo.png")
			{
				// Vanilla does not show the maximum ammunition. We now also color the remaining ammunition in the negative color if it is 0
				entry.text = "Remaining Ammo: " + ::MSU.Text.colorizeValue(this.getAmmo(), {CompareTo = 1}) + " / " + this.getAmmoMax();
			}
		}

		return ret;
	}
});
