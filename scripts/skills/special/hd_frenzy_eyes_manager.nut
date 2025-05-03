this.hd_frenzy_eyes_manager <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.hd_frenzy_eyes_manager";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = ::Const.SkillType.Special;
		this.m.Order = ::Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function onAfterUpdate( _properties )
	{
		// This effect is only added to characters who have this sprite, so we don't need to check for the sprites existance
		this.getContainer().getActor().getSprite("HD_frenzy_eyes").Visible = _properties.ShowFrenzyEyes;
	}
});
