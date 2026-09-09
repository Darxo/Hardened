// Fix: prevent the main town dialog from rarely remaining positioned outside the screen
// Vanilla uses translateX to slide the main dialog back in when returning from another town screen.
// If this animation is interrupted, the dialog can retain its initial positive translateX.
// In the observed case it retained 2624px, exactly matching parent width (1600) + dialog width (1024).

// On a later town entry, show(false) only resets opacity and therefore preserves this stale translation.
// The town screen otherwise opens normally, but its main dialog is positioned entirely outside the viewport.
// The player appears stuck after entering the town, although ESC can still be used to leave.

// The broken state can be verified in the JS console with:
// return $(".l-main-dialog-container").css("transform")
// return $(".l-main-dialog-container").offset().left
//
// It can be repaired without restarting the game with:
// $(".l-main-dialog-container").velocity({ translateX: 0 }, { duration: 0 });

// Reproduction:
// Write this into the dev console while in javascript mode:
// var c = $(".l-main-dialog-container"); var offset = c.parent().width() + c.width(); c.velocity({ translateX: offset }, { duration: 0 });
// Try to enter a town
Hardened.Hooks.WorldTownScreenMainDialogModule_show = WorldTownScreenMainDialogModule.prototype.show;
WorldTownScreenMainDialogModule.prototype.show = function (_withSlideAnimation)
{
	// Always start show() from translateX 0. The animated path immediately replaces this with its intended
	// starting offset, while the non-animated path is protected from stale state left by a previous animation.
	// Use Velocity's hook to reset its internal transform state synchronously without queuing another animation.
	$.Velocity.hook(this.mContainer, "translateX", "0px");
	Hardened.Hooks.WorldTownScreenMainDialogModule_show.call(this, _withSlideAnimation);
}
