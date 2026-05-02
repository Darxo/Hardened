// We design this weapon from a Longsword-Like into a Warbrand-Like
::Hardened.HooksMod.hook("scripts/items/weapons/named/named_rf_draugr_greatsword", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We Buff the base stats of this item a bit beyond the base Warband to make it stand apart more, similar to named_rf_draugr_bardiche
		this.m.Value = 4000;				// Reforged: 3200
		this.m.ShieldDamage = 0;			// Reforged: 24
		this.m.ConditionMax = 70.0;			// Reforged: 70.0
		this.m.StaminaModifier = -14;		// Reforged: -16
		this.m.RegularDamage = 70;			// Reforged: 60
		this.m.RegularDamageMax = 80;		// Reforged: 80
		this.m.ArmorDamageMult = 0.75;		// Reforged: 1.1
		this.m.DirectDamageMult = 0.3;		// Reforged: 0.25
		this.m.DirectDamageAdd = 0.0;		// Reforged: 0.05
		this.m.ChanceToHitHead = 0;			// Reforged: 10
		this.m.Reach = 6;					// Reforged: 6

		this.randomizeValues();
	}

	// Overwrite, because we dont change the skill costs and add a different set of skills
	q.onEquip = @() function()
	{
		this.__setNameBasedOnChampion();
		this.named_weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/slash"));
		this.addSkill(::new("scripts/skills/actives/split"));
		this.addSkill(::new("scripts/skills/actives/swing"));
		this.addSkill(::new("scripts/skills/actives/riposte"));
	}
});
