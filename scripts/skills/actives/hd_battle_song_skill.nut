this.hd_battle_song_skill <- ::inherit("scripts/skills/skill", {
	m = {
		ResolveBonusPct = 0.2,
	},
	function create()
	{
		this.m.ID = "actives.hd_battle_song";
		this.m.Name = "Play Battle Song";
		this.m.Description = "Play a song on your musical instrument to raise the Resolve of nearby allies. Cannot be used while engaged in melee."
		this.m.Icon = "skills/hd_battle_song_skill.png";
		this.m.IconDisabled = "skills/hd_battle_song_skill_bw.png";
		this.m.Overlay = "hd_battle_song_skill";
		this.m.SoundOnUse = [
			"sounds/combat/hd_lute_song_02.wav",
			"sounds/combat/hd_lute_song_03.wav",
			"sounds/combat/hd_lute_song_04.wav",
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString("Grant a stacking [Inspired by Song|Skill+hd_inspired_by_song_effect] effect to all allies within " + ::MSU.Text.colorPositive(this.getMaxRange()) + " tiles adding " + ::MSU.Text.colorizePct(this.m.ResolveBonusPct) + " (" + ::MSU.Text.colorizeValue(this.getBonus()) + ") of your current [Resolve|Concept.Bravery] to them"),
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Does not affect allies who are currently inspired by someone else\'s song",
			},
		]);

		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap() && actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because this character is [engaged|Concept.ZoneOfControl] in melee"),
			});
		}

		return ret;
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
				local effect = ::new("scripts/skills/effects/hd_inspired_by_song_effect");
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
		return ::Math.max(0, ::Math.floor(this.getContainer().getActor().getCurrentProperties().getBravery() * this.m.ResolveBonusPct));
	}
});
