::MSU.Vanilla.Keybinds.addSQKeybind("tactical_initNextTurn", "f/enter", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	 ::Tactical.TurnSequenceBar.HD_endPlayerTurn();
	return true;
}, "End Turn for Character");
