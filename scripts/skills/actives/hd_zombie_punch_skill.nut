this.hd_zombie_punch_skill <- this.inherit("scripts/skills/actives/zombie_bite", {
	m = {
	},
	function create()
	{
		this.zombie_bite.create();
		this.m.ID = "actives.hd_zombie_punch_skill";
		this.m.Name = "Zombie Punch";
		this.m.Description = "Use your rotten fists to deliver a painful punch.";
		this.m.KilledString = "Pummeled to death";
		this.m.Icon = "skills/active_08.png";
		this.m.IconDisabled = "skills/active_08_sw.png";
		this.m.Overlay = "active_08";
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
	}

	function onUpdate( _properties )
	{
		// Revert changes to headshot chance
		local oldHitChanceHead = _properties.HitChance[::Const.BodyPart.Head];
		this.zombie_bite.onUpdate(_properties);
		_properties.HitChance[::Const.BodyPart.Head] = oldHitChanceHead;
	}
});
