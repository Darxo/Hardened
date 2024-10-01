this.hd_inspiring_presence_buff_effect <- ::inherit("scripts/skills/skill", {
	m = {
		BonusActionPoints = 3
		HasHadTurnYet = false
	},
	function create()
	{
		this.m.ID = "effects.hd_inspiring_presence_buff";
		this.m.Name = "Feeling Inspired";
		this.m.Description = "This character started the round in the presence of a highly inspiring character!";
		this.m.Icon = "skills/rf_inspiring_presence_buff_effect.png";
		this.m.Type = ::Const.SkillType.Special | ::Const.SkillType.StatusEffect;
		this.m.SoundOnUse = [
			"sounds/combat/rf_inspiring_presence_01.wav",
			"sounds/combat/rf_inspiring_presence_02.wav",
			"sounds/combat/rf_inspiring_presence_03.wav"
		];
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsStacking = false;
	}

	function getTooltip()
	{
		local tooltip = this.skill.getTooltip();

		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.BonusActionPoints, {AddSign = true}) + " [Action Points|Concept.ActionPoints]"),
		});

		return tooltip;
	}

	function onAdded()
	{
		this.spawnIcon("rf_inspiring_presence_buff_effect", this.getContainer().getActor().getTile());

		// Maybe playing 6 of these at the same time ends up too dank. But for now I will leave it like this
		::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Skill * this.m.SoundVolume, this.getContainer().getActor().getPos());
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += this.m.BonusActionPoints;

		if (this.m.HasHadTurnYet == false)
		{
			this.getContainer().getActor().setActionPoints(this.getContainer().getActor().getActionPointsMax() + this.m.BonusActionPoints);
			this.m.HasHadTurnYet = true;
		}
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}
});
