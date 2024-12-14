this.hd_lindwurm_tail_racial <- this.inherit("scripts/skills/racial/lindwurm_racial", {
	m = {},

	function create()
	{
		this.lindwurm_racial.create();

		this.m.Name = "Lindwurm Tail";
	}

	function getTooltip()
	{
		local ret = this.lindwurm_racial.getTooltip();

		foreach (entry in ret)
		{
			// These two effects are implemented in lindwurm.nut
			if (entry.id == 27)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Whenever the head moves away, remove all [rooted|Concept.Rooted] effects");
			}
			else if (entry.id == 28)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Whenever the head moves away, remove [stunned|Skill+stunned_effect]");
			}
		}

		return ret;
	}

	function onAdded()
	{
		this.lindwurm_racial.onAdded();

		local baseProperties = this.getContainer().getActor().getBaseProperties();

		baseProperties.IsImmuneToStun = false;
		baseProperties.IsImmuneToRoot = false;
	}
});
