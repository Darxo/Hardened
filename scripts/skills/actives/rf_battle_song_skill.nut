this.rf_battle_song_skill <- ::inherit("scripts/skills/skill", {
	m = {
		ResolveBuffPercentage = 20
	},
	function create()
	{
		this.m.ID = "actives.rf_battle_song";
		this.m.Name = "Play Battle Song";
		this.m.Description = "Play a song on your musicial instrument to raise the Resolve of nearby allies. This buff loses effectiveness over time and is removed when reaching a threshold. Can not be used while engaged in melee."
		this.m.Icon = "skills/rf_battle_song_skill.png";
		this.m.IconDisabled = "skills/rf_battle_song_skill_bw.png";
		this.m.Overlay = "rf_battle_song_skill";
		this.m.SoundOnUse = [
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getDefaultUtilityTooltip();

		tooltip.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Grant \'Inspired by Song\' effect to all allies within " + ::MSU.Text.colorPositive(this.getMaxRange()) + " tiles adding " + ::MSU.Text.colorPositive(this.m.ResolveBuffPercentage + "%") + " of your current Resolve to them or increase the current bonus of an existing effect by the same amount."
			},
			{
				id = 10,
				type = "text",
				text = "Does not affect allies who are currently inspired by someone elses song."
			}
		]);

		if (::Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return tooltip;
	}

	function onUse( _user, _targetTile )
	{
		foreach (ally in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()))
		{
			if (ally.getTile().getDistanceTo(_user.getTile()) > this.getMaxRange()) continue;
			if (ally.getID() == _user.getID()) continue;

			local existingSkill = ally.getSkills().getSkillByID("effects.rf_inspired_by_song");
			if (existingSkill == null)
			{
				local effect = ::new("scripts/skills/effects/rf_inspired_by_song_effect");
				effect.init(_user, this.getBonus());
				ally.getSkills().add(effect);
				continue;
			}
			else if (existingSkill.m.Musician.getID() == _user.getID())		// You can only stack songs from the same musician
			{
				existingSkill.increaseBonus(this.getBonus());
			}
		}
		return true;
	}

	function getBonus()
	{
		return ::Math.max(0, ::Math.floor(this.getContainer().getActor().getCurrentProperties().getBravery() * this.m.ResolveBuffPercentage / 100.0));
	}
});
