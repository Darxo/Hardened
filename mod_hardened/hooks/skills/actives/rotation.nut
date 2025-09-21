::Hardened.HooksMod.hook("scripts/skills/actives/rotation", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		// MSU Members:
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.Rotation;		// Any NPC who gains the rotation perk now automatically gets the respective ai behavior to utilize it
	}}.create;
});
