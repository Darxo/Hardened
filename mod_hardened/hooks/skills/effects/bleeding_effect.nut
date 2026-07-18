::Hardened.HooksMod.hook("scripts/skills/effects/bleeding_effect", function(q) {
	q.m.HD_BloodEffectPctPerStack <- 0.05;		// Each stack causes the bleed effect animation to be this much larger

// Private
	q.m.HD_LastKnownStacks <- 0;
	q.m.HD_IconBaseName <- "skills/hd_bleeding_";
	q.m.HD_MiniIconBaseName <- "hd_bleeding_mini_";

	q.applyDamage = @(__original) function()
	{
		if (this.m.LastRoundApplied != ::Time.getRound())	// Same condition as original
		{
			local actor = this.getContainer().getActor()
			actor.spawnBloodEffect(actor.getTile(), this.m.Stacks * this.m.HD_BloodEffectPctPerStack);
		}

		__original();
	}

	q.onAdded = @(__original) function()
	{
		__original();
		this.HD_onBleedingStacksChanged();
	}

	q.onRefresh = @(__original) function()
	{
		__original();
		this.HD_onBleedingStacksChanged();
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.m.Stacks != this.m.HD_LastKnownStacks)
		{
			this.m.HD_LastKnownStacks = this.m.Stacks;
			this.HD_onBleedingStacksChanged();
		}
	}

	q.HD_onBleedingStacksChanged <- function()
	{
		this.m.Icon = this.m.HD_IconBaseName + ::Math.clamp(this.m.Stacks, 1, 5) + ".png";
		this.m.IconMini = this.m.HD_MiniIconBaseName + ::Math.clamp(this.m.Stacks, 1, 5);
		this.getContainer().getActor().setDirty(true);
	}
});
