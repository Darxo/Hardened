::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/sand_golem", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.steel_brow");
		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_man_of_steel"));

		this.onSizeChanged();	// just in case there are some effects coded into happening at the default size
	}

	q.grow = @(__original) function( _instant = false )
	{
		__original(_instant);
		this.onSizeChanged();
	}

	q.shrink = @(__original) function( _instant = false )
	{
		__original(_instant);
		this.onSizeChanged();
	}

// New Functions
	// This is called once after and whenever this character grows or shrinks
	q.onSizeChanged <- function()
	{
		local baseProp = this.getBaseProperties();
		switch (this.m.Size)
		{
			case 1:
			{
				this.getSkills().removeByID("perk.rf_marksmanship");
				baseProp.ArmorMax[0] = 165;	// In Vanilla this is 110
				break;
			}
			case 2:
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_marksmanship"));
				baseProp.ArmorMax[0] = 220;	// In Vanilla this is 110
				break;
			}
			case 3:
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_marksmanship"));
				baseProp.ArmorMax[0] = 330;	// In Vanilla this is 110
				break;
			}
		}

		// Regenerate all armor
		baseProp.Armor[0] = baseProp.ArmorMax[0];
	}
});
