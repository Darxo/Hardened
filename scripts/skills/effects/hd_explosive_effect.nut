this.hd_explosive_effect <- ::inherit("scripts/skills/skill", {
	m = {
	},

	function create()
	{
		this.m.ID = "effects.hd_explosive";
		this.m.Name = "Explosive";
		this.m.Description = "You could explode at any moment!";
		this.m.Icon = "skills/hd_explosive_effect.png";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/stat_screen_dmg_dealt.png",	// Same Icon as Reach in Reforged
			text = ::Reforged.Mod.Tooltips.parseString("On death, use [$ $|Skill+hd_explode_skill,entityId:" + this.getContainer().getActor().getID() + "] for free on all adjacent characters"),
		});

		return ret;
	}

	function onAdded()
	{
		// Add the dummy damage skill, which we use to apply the damage and provide a detailed tooltip
		this.getContainer().add(::new("scripts/skills/actives/hd_explode_skill"));
	}

	function onDeath( _fatalityType )
	{
		local actor = this.getContainer().getActor();
		if (!actor.isHiddenToPlayer())
		{
			this.HD_playExplosionAnimation();
		}

		local explodeSkill = this.getContainer().getSkillByID("actives.hd_explode");
		foreach (nextTile in ::MSU.Tile.getNeighbors(actor.getTile()))
		{
			if (!explodeSkill.HD_isUsableOnForFree(nextTile)) continue;
			explodeSkill.useForFree(nextTile);
		}
	}

// New Functions
	function HD_playExplosionAnimation()
	{
		local myTile = this.getContainer().getActor().getTile();
		local effect = {
			Delay = 0,
			Quantity = 80,
			LifeTimeQuantity = 80,
			SpawnRate = 400,
			Brushes = [
				"blood_splatter_bones_01",
				"blood_splatter_bones_03",
				"blood_splatter_bones_04",
				"blood_splatter_bones_05",
				"blood_splatter_bones_06"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffffff"),
					ColorMax = ::createColor("ffffffff"),
					ScaleMin = 1.0,
					ScaleMax = 1.5,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 200,
					VelocityMax = 300,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					SpawnOffsetMin = ::createVec(0, 0),
					SpawnOffsetMax = ::createVec(0, 0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.75,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff8f"),
					ColorMax = ::createColor("ffffff8f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 200,
					VelocityMax = 300,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, -100),
					ForceMax = ::createVec(0, -100)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 200,
					VelocityMax = 300,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, -100),
					ForceMax = ::createVec(0, -100)
				}
			]
		};
		::Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 50));
	}
});
