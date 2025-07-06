::Hardened.HooksMod.hook("scripts/entity/tactical/humans/swordmaster", function(q) {
	q.onInit = @(__original) { function onInit()
	{
		__original();

		this.m.MyVariant = ::MSU.Array.rand([
			this.m.SwordmasterVariants.Versatile,
			this.m.SwordmasterVariants.BladeDancer,
			this.m.SwordmasterVariants.Metzger,
		]);
		this.m.MyArmorVariant = ::Math.rand(0, 1); // 0 = Light Armor, 1 = Medium Armor

		// Swordmaster is now always a pure 1-handed character, so he has Duelist at all times
		this.getSkills().add(::new("scripts/skills/perks/perk_duelist"));

		// Parry replaces Dodge as THE defensive perk
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_parry"));
		this.getSkills().removeByID("perk.dodge");

		// Calcualted Strieks replaces Executioner as THE damage perk
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_calculated_strikes"));
		this.getSkills().removeByID("perk.coup_de_grace");
	}}.onInit;

	q.assignRandomEquipment = @(__original) function()
	{
		// We need to check for empty slots because we dont want to overwrite named weapons, as makeMiniboss happens first
		// We need to this first, because after Reforged assigned their weapons, the mainhand will no longer be empty
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Mainhand))
		{
			// All Swordmaster now use named one-handed swords at all times
			if (this.m.MyVariant == this.m.SwordmasterVariants.Metzger)
			{
				this.getItems().equip(::new("scripts/items/weapons/shamshir"));
			}
			else
			{
				this.getItems().equip(::new("scripts/items/weapons/noble_sword"));
			}
		}

		__original();

		local shield = this.getOffhandItem();
		if (shield != null) this.getItems().unequip(shield);
	}

	q.makeMiniboss = @(__original) function()
	{
		__original();

		local mainhandItem = this.getMainhandItem();
		if (mainhandItem != null && mainhandItem.isNamed())
		{
			// All Swordmaster now use named one-handed swords at all times
			if (this.m.MyVariant == this.m.SwordmasterVariants.Metzger)
			{
				::Hardened.util.replaceMainhand(this, "scripts/items/weapons/named/named_shamshir");
			}
			else
			{
				::Hardened.util.replaceMainhand(this, "scripts/items/weapons/named/named_sword");
			}
		}
	}

	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.rf_formidable_approach");		// Swordmaster no longer use 2H weapons so
	}
});
