this.hd_bag_item_silhouettes <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.hd_bag_item_silhouettes";
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

	function onUpdate( _properties )
	{
		local silhouettesHidden = !this.isShowing();
		local actor = this.getContainer().getActor();
		local bagItems = actor.getItems().m.Items[::Const.ItemSlot.Bag];
		foreach (index, item in bagItems)
		{
			local spriteName = actor.m.HD_BagSlotSpriteName + index;
			if (!actor.hasSprite(spriteName)) continue;

			local sprite = actor.getSprite(spriteName);
			sprite.Visible = false;

			if (silhouettesHidden) continue;
			if (item == null ||item == -1) continue;

			local silhouette = item.HD_getSilhouette();
			if (silhouette == null) continue;

			sprite.setBrush(silhouette);
			sprite.Visible = true;
			sprite.Color = ::createColor(this.getColor());
			// A small offset for simulating depth is imaginable (using actor.setSpriteOffset)
			// However that only affects actors on the battlefield. Actors in the character screen and on the turn sequence bar will be unaffected by those offsets
		}
	}

// New Functions
	function isShowing()
	{
		return this.getAlpha() > 0;
	}

	function getAlpha()
	{
		return ::Hardened.Mod.ModSettings.getSetting("BagSilhouetteAlpha").getValue();
	}

	function getColor()
	{
		local color = "";

		local colorCode = ::Hardened.util.intToHex(::Hardened.Mod.ModSettings.getSetting("BagSilhouetteColor").getValue());
		for (local i = 1; i <= 3; ++i)
		{
			color += colorCode;
		}

		color += ::Hardened.util.intToHex(this.getAlpha());

		return color;
	}
});
