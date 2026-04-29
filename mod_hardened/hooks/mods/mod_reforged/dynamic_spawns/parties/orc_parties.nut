{	// Hooking
	::Reforged.Spawns.Parties["OrcRoamers"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs;
	::Reforged.Spawns.Parties["OrcScouts"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs;
	::Reforged.Spawns.Parties["OrcRaiders"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs;
	::Reforged.Spawns.Parties["OrcDefenders"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs * ::Hardened.Global.PartySizeMult.Location;
	::Reforged.Spawns.Parties["OrcBoss"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs * ::Hardened.Global.PartySizeMult.Location;
	::Reforged.Spawns.Parties["YoungOrcsOnly"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs * ::Hardened.Global.PartySizeMult.Location;
	::Reforged.Spawns.Parties["YoungOrcsAndBerserkers"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs * ::Hardened.Global.PartySizeMult.Location;
	::Reforged.Spawns.Parties["BerserkersOnly"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Orcs * ::Hardened.Global.PartySizeMult.Location;
}
