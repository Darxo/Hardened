::Hardened.HooksMod.hook("scripts/ui/screens/world/modules/world_town_screen/town_hire_dialog_module", function(q)
{
// New Functions
	q.onDismissButtonPressed <- function( _entityID )
	{
		local entity = this.findEntityWithinRoster(_entityID)
		if (entity == null)
		{
			return {
				Result = ::Const.UI.Error.RosterEntryNotFound,
				Assets = null,
			};
		}

		// "sounds/scribble.wav" is another noteworthy one (crossing out a name from list), but it goes on for a bit too long
		// and overusing it here takes away from its charm on accepting contracts
		::Sound.play("sounds/cloth_01.wav", ::Math.rand(70, 80) * 0.01, ::World.State.getPlayer().getPos(), ::Math.rand(90, 110) * 0.01);	// We add some variation in volume and pitch
		::World.getRoster(this.m.RosterID).remove(entity);

		// Not sure, why this is important, but Vanilla does it after hiring
		if (::World.getRoster(this.m.RosterID).getSize() == 0)
		{
			this.m.Parent.getMainDialogModule().reload();
		}

		return {
			Result = 0,
			Assets = this.m.Parent.queryAssetsInformation(),
		};
	}
});
