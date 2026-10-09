::Hardened.HooksMod.hook("scripts/ui/global/cursor", function(q) {
	// Can be controlled from outside to force a different cursor icon
	// We use this instead of calling setCursor ourselves, because calling setCursor multiple times (when hooking) causes flicker
	q.m.HD_CursorOverwrite <- null;

	q.setCursor = @(__original) { function setCursor( _brush )
	{
		if (this.m.HD_CursorOverwrite != null) _brush = this.m.HD_CursorOverwrite;

		__original(_brush);
	}}.setCursor;
});
