// Adjusted split_shield skill that can be used without any weapon and deals a flat, hard-coded amount of Shield Damage
// Meant to appear on certain beasts
this.hd_beast_split_shield <- this.inherit("scripts/skills/actives/split_shield", {
	m = {
		HD_ShieldDamage = 50,
	},
	function create()
	{
		this.split_shield.create();
		this.m.IsWeaponSkill = false;	// Otherwise its disabled while disarmed. Although someone without a weapon can't be disarmed anyways
		this.m.ActionPointCost = 5;		// split_shield: 6
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.SplitShield;
	}

// Hardened Functions
	function getShieldDamage()
	{
		return this.m.HD_ShieldDamage;
	}
});

