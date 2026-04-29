{	// Hooking
	::Reforged.Spawns.Parties["GoblinRoamers"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Goblins;
	::Reforged.Spawns.Parties["GoblinScouts"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Goblins;
	::Reforged.Spawns.Parties["GoblinRaiders"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Goblins;
	::Reforged.Spawns.Parties["GoblinDefenders"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Goblins * ::Hardened.Global.PartySizeMult.Location;
	::Reforged.Spawns.Parties["GoblinBoss"].IdealSizeMult <- ::Hardened.Global.FactionIdealSizeMult.Goblins * ::Hardened.Global.PartySizeMult.Location;
}
