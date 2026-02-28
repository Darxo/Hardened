::Hardened.HooksMod.hook("scripts/skills/backgrounds/character_background", function(q) {
	// Public
	q.m.CostMultPerRegularLevel <- 1.1;		// Every Regular Level above 1 increases this characaters wage by this amount multiplicatively
	q.m.CostMultPerVeteranLevel <- 1.03;	// Every Veteran Level above 1 increases this characaters wage by this amount multiplicatively

	// Overwrite, because we make the daily cost calculation more moddable and less hard-coded
	q.onUpdate = @() { function onUpdate( _properties )
	{
		if (this.m.DailyCost == 0 || this.getContainer().hasSkill("trait.player"))
		{
			// Same logic as in Vanilla
			_properties.DailyWage = 0;
		}
		else
		{
			// Feat: We slightly rework the vanilla wage calculation
			// - We use ::Const.XP.MaxLevelWithPerkpoints instead of a hard-coded 10
			// - We introduce new CostMultPerRegularLevel and CostMultPerVeteranLevel member to allow beter changes by mods
			// - We use more helper variables to improve readability
			local level = this.getContainer().getActor().getLevel();
			local wage = ::Math.round(this.m.DailyCost * this.m.DailyCostMult);
			local regularLevels = ::Math.min(level, ::Const.XP.MaxLevelWithPerkpoints) - 1;
			local veteranLevels = ::Math.max(level - ::Const.XP.MaxLevelWithPerkpoints, 0);

			local scaledWage = wage * ::Math.pow(this.m.CostMultPerRegularLevel, regularLevels);
			if (level > 11)
			{
				scaledWage *= ::Math.pow(this.m.CostMultPerVeteranLevel, veteranLevels);
			}
			_properties.DailyWage += scaledWage;
		}

		// Same Hard-Coded experience penalty implementtion for manhunter origin as in Vanilla
		if (("State" in ::World) && ::World.State != null && ::World.Assets.getOrigin() != null && ::World.Assets.getOrigin().getID() == "scenario.manhunters" && this.getID() != "background.slave")
		{
			_properties.XPGainMult *= 0.9;
		}
	}}.onUpdate;
})
