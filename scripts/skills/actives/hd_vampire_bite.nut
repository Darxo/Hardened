this.hd_vampire_bite <- this.inherit("scripts/skills/actives/zombie_bite", {
	m = {},
	function create()
	{
		this.zombie_bite.create();
		this.m.ID = "actives.hd_vampire_bite";
		this.m.Name = "Vampire Bite";
		this.m.Description = "Use your sharp teeth to deliver a painful bite.";
		this.m.InjuriesOnBody = ::Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = ::Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.6;	// zombie_bite: 0.1

	// MSU Members:
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.AttackDefault;
	}
});

