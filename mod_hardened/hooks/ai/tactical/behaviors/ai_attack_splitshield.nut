::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_splitshield", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		// Our goal is to prevent vanilla assuming that the character must have a mainhand weapon equipped which provides the shield damage
		// Instead, when vanilla asks for "getItemAtSlot" the first time, we return this.m.Skill, which also contains getShieldDamage
		local self = this;
		local mockObject = ::Hardened.mockFunction(_entity.getItems(), "getItemAtSlot", function( _slotType ) {
			if (_slotType == ::Const.ItemSlot.Mainhand)
			{
				if ("getShieldDamage" in self.m.Skill)	// If that function does not exist here, than another mod might have added a new skill to this ai behavior
				{
					return { done = true, value = self.m.Skill };
				}
				return { done = true };
			}
		});

		local ret = __original(_entity);	// Variable to hold the value yielded by the generator

		mockObject.cleanup();

		return ret;
	}
});
